Shader "Custom/Grass"
{
    Properties
    {
        [Header(Color)]
        _TopColor("TopColor", Color) = (1, 1, 1, 1)
        _BottomColor("BottomColor",Color) = (0,0,0,1)
        _ColorGradientMin("ColorGradientMin",Range(-0.5,0.5)) = 0
        _ColorGradientMax("_ColorGradientMin",Range(0.5,1.5)) = 1
        _RimColor ("RimColor",Color) = (1.0,1.0,1.0,1.0)
        _RimPower("RimPower",Float) = 1.0
        _RimScale("RimScale",Float) = 1.0
        [Header(Rotate)]
        _NoiseMap("NoiseMap",2D) = "black"{}
        _NoiseScale("NoiseScale",Float) = 1.0
        _RotateXY("RotateXY",Vector) = (0.5,0.5,0.1,-0.2)
        [Header(Shape)]
        _BaseHeight("BaseHeight",Range(0,1)) = 0.2
        _BaseWidth("BaseWidth",Range(0,1))= 0.1
        _RandomHeight("RandomHeight",Float) = 0.05
        _RandomWidth("RandomWidth",Float) = 0.01
        _HeightChange("HeightChange",Float) = 1.0
        [Header(Tellessation)]
        _Tess("Tess",Range(1,32)) = 20
    }

    CGINCLUDE

        #include "Lighting.cginc"
    
        #define BLADE_SEGMENTS 3
    
        half4 _TopColor;
        half4 _BottomColor;
        half _ColorGradientMin;
        half _ColorGradientMax;
        half4 _RimColor;
        half _RimPower;
        half _RimScale;
        
        sampler2D _NoiseMap;
        half _NoiseScale;
        half4 _RotateXY;

        half _BaseHeight;
        half _BaseWidth;
        half _RandomHeight;
        half _RandomWidth;
        half _HeightChange;

        half _Tess;
    
        struct VertexInput
            {
                float4 vertex : POSITION;
                float4 vertexColor :COLOR;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct VertexOut
            {
                float4 vertex : SV_POSITION;
                float4 vertexColor : COLOR;
                float3 normal : NORMAL;
                float4 tangent :TANGENT;
            };
            
            struct TessellationFactors 
            {
            	float edge[3] : SV_TessFactor;
            	float inside : SV_InsideTessFactor;
            };


            struct geometryOutput
            {
                float4 pos : SV_POSITION;
                float3 pos_world : TEXCOORD2;
                float2 uv :TEXCOORD0;
                float3 normal : TEXCOORD1;
            };

            //顶点着色器将顶点信息传送给几何着色器
            VertexInput vert (VertexInput i)
			{
                return i;
			}

            VertexOut tessVert(VertexInput v)
            {
            	VertexOut o;
            	// Note that the vertex is NOT transformed to clip
            	// space here; this is done in the grass geometry shader.
            	o.vertex = v.vertex;
            	o.normal = v.normal;
            	o.tangent = v.tangent;
                o.vertexColor = v.vertexColor;
            	return o;
            }
            TessellationFactors patchConstantFunction (InputPatch<VertexInput, 3> patch)
            {
            	TessellationFactors f;
            	f.edge[0] = _Tess * patch[0].vertexColor.r;
            	f.edge[1] = _Tess * patch[0].vertexColor.r;
            	f.edge[2] = _Tess * patch[0].vertexColor.r;
            	f.inside = _Tess * patch[0].vertexColor.r;
            	return f;
            }
            [domain("tri")]//明确地告诉编译器正在处理三角形，其他选项：
            [outputcontrolpoints(3)]//明确地告诉编译器每个补丁输出三个控制点
            [outputtopology("triangle_cw")]//当GPU创建新三角形时，它需要知道我们是否要按顺时针或逆时针定义它们
            [partitioning("fractional_odd")]//告知GPU应该如何分割补丁，现在，仅使用整数模式
            [patchconstantfunc("patchConstantFunction")]//GPU还必须知道应将补丁切成多少部分。这不是一个恒定值，每个补丁可能有所不同。必须提供一个评估此值的函数，称为补丁常数函数（Patch Constant Functions）
            VertexInput hull (InputPatch<VertexInput, 3> patch, uint id : SV_OutputControlPointID)
            {
            	return patch[id];
            }
            [domain("tri")]
            VertexOut domain(TessellationFactors factors, OutputPatch<VertexInput, 3> patch, float3 barycentricCoordinates : SV_DomainLocation)
            {
            	VertexInput v;
            
            	#define MY_DOMAIN_PROGRAM_INTERPOLATE(fieldName) v.fieldName = \
            		patch[0].fieldName * barycentricCoordinates.x + \
            		patch[1].fieldName * barycentricCoordinates.y + \
            		patch[2].fieldName * barycentricCoordinates.z;
            
            	MY_DOMAIN_PROGRAM_INTERPOLATE(vertex)
            	MY_DOMAIN_PROGRAM_INTERPOLATE(normal)
            	MY_DOMAIN_PROGRAM_INTERPOLATE(tangent)
            	MY_DOMAIN_PROGRAM_INTERPOLATE(vertexColor)
            
            	return tessVert(v);
            }

            
            //几何着色器获取顶点信息，并根据所要绘制的图形修改并向TriangleStream传入顶点信息，
            geometryOutput VertexOutput(float3 pos,float2 uv,float3 normal)
            {
                geometryOutput o;
                o.uv = uv;
                o.pos = UnityObjectToClipPos(pos);
                o.pos_world = mul(unity_ObjectToWorld,pos).xyz;
                o.normal = normal;
                return o;
            }
            geometryOutput GenerateGrassVertex(float3 vertexPosition, float width, float height,
                                   float2 uv, float3x3 transformMatrix,float3 normal)
            {
                float3 tangentPoint = float3(width, 0, height);
                float3 localPosition = vertexPosition + mul(transformMatrix, tangentPoint);
                return VertexOutput(localPosition, uv,normal);
            }
            //生成随机旋转角度
            float rand(float3 co)
            {
                return frac(sin(dot(co.xyz, float3(12.9898, 78.233, 53.539))) * 43758.5453);
            }
            //根据输入的角度和方向，生成旋转矩阵
            float3x3 AngleAxis3x3(float angle, float3 axis)
            {
                float c, s;
                sincos(angle, s, c);//s是angle的正弦值，c是angle的余弦值
            
                float t = 1 - c;
                float x = axis.x;
                float y = axis.y;
                float z = axis.z;
                return float3x3(
                    t * x * x + c, t * x * y - s * z, t * x * z + s * y,
                    t * x * y + s * z, t * y * y + c, t * y * z - s * x,
                    t * x * z - s * y, t * y * z + s * x, t * z * z + c
                );
            }
            [maxvertexcount(BLADE_SEGMENTS * 2 + 1)]
            void geo(triangle  VertexOut IN[3] : SV_POSITION,inout TriangleStream<geometryOutput> triStream)
            {
                half2 vertexControlHW = IN[0].vertexColor.gb;
                half3 pos = IN[0].vertex;
                half3 normal = IN[0].normal;
                half4 tangent = IN[0].tangent;
                half3 binormal = cross(normal,tangent) * tangent.w;
                half3x3 TBN = float3x3(
                    tangent.x,binormal.x,normal.x,
                    tangent.y,binormal.y,normal.y,
                    tangent.z,binormal.z,normal.z
                    );

                half2 noise_uv =  pos.xz/_NoiseScale + _RotateXY.zw * _Time;
                half waveIntensity =saturate(tex2Dlod(_NoiseMap,float4(noise_uv,0,0)).r) ;
                //生成随机的沿y轴旋转的矩阵
                half3x3 randomRotationMatrixZ = AngleAxis3x3(rand(pos) * 1.57075,float3(0,0,1));
                half3x3 randomRotationMatrixX = AngleAxis3x3(_RotateXY.x *3.14 * waveIntensity,float3(1,0,0));
                half3x3 randomRotationMatrixY = AngleAxis3x3(_RotateXY.y *3.14 * waveIntensity,float3(0,1,0));
                half3x3 randomRotationMatrix = mul(mul(randomRotationMatrixZ,randomRotationMatrixY),randomRotationMatrixX);
                half3x3 transformFinal = mul(TBN,randomRotationMatrix);//弦进行角度转换，再进行TBN切线空间转换
                float3x3 transformationMatrixFacing = mul(TBN,randomRotationMatrixZ);
                //由于我们想要实现草的底部是不会随着草的旋转而旋转的效果，因此，草的底部相乘的矩阵是最简单的沿Y轴旋转的矩阵，其它点是沿XYZ轴旋转的综合矩阵
                //根据切向空间，将顶点转换到相应的法线位置  x(切线tangent),y(切线binormal),z(法线normal)
                half width = (_BaseWidth + (rand(pos.xyz)*2 - 1) * _RandomWidth)*vertexControlHW.x;
                half height = (_BaseHeight + (rand(pos.zyx)*2 - 1) * _RandomHeight)*vertexControlHW.y;
                /*triStream.Append(GenerateGrassVertex(pos, width, 0, float2(0, 0),
                                                     transformationMatrixFacing));
                triStream.Append(GenerateGrassVertex(pos, -width, 0, float2(1, 0),
                                                     transformationMatrixFacing));
                triStream.Append(GenerateGrassVertex(pos, 0, height, float2(0.5, 1),
                                                     transformFinal));*/
                //循环生成顶点，生成类似草的几何图形
                for (int i = 0; i < BLADE_SEGMENTS; i++)
                {
                    // t表示遍历的进度，值在0~1，用于计算梯形底边的宽以及底边所处的高度
                    float t = i / (float)BLADE_SEGMENTS;
                    
                    // 计算宽高
                    float segmentHeight = height * t;
                    float segmentWidth = width * (1 - t);
                    half3x3 final = transformFinal; 
                    if (i!=0)
                    {
                        half ramdom = waveIntensity + t * rand(pos.xxz) * _HeightChange;
                        randomRotationMatrixX = AngleAxis3x3(_RotateXY.x *3.14 * ramdom,float3(1,0,0));
                        randomRotationMatrixY = AngleAxis3x3(_RotateXY.y *3.14 * ramdom,float3(0,1,0));
                        randomRotationMatrix = mul(mul(randomRotationMatrixZ,randomRotationMatrixY),randomRotationMatrixX);
                        final = mul(TBN,randomRotationMatrix);
                    }
                    
                    // 最底部的顶点使用transformationMatrixFacing变换矩阵
                    float3x3 transformMatrix = (i == 0 ? transformationMatrixFacing : final);
                    
                    // 添加顶点
                    triStream.Append(GenerateGrassVertex(pos, segmentWidth, segmentHeight, float2(0, t),
                                                         transformMatrix,normal));
                    triStream.Append(GenerateGrassVertex(pos, -segmentWidth, segmentHeight, float2(1, t),
                                                         transformMatrix,normal));
                }

                // for循环结束后需要将小草叶片最顶部的顶点加入输出流中
                triStream.Append(GenerateGrassVertex(pos, 0, height, float2(0.5, 1),
                                                         transformFinal,normal));
            }

    ENDCG

    SubShader
    {
        Cull Off

        Pass
        {
            Tags
            {
                "RenderType" = "Opaque"
                "LightMode" = "ForwardBase"
            }

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geo
            #pragma target 4.6
            #pragma hull hull //细分着色器
            #pragma domain domain

            half4 frag(geometryOutput i) : SV_Target
            {
                //常量
                half gradientY = i.uv.y;
                gradientY = smoothstep(_ColorGradientMin,_ColorGradientMax,gradientY);
                half3 view_dir = normalize(_WorldSpaceCameraPos - i.pos_world);
                half3 normal_dir = normalize(i.normal);
                
                //贴图
                half3 heightColor = lerp(_BottomColor,_TopColor,gradientY);
                //half3 color = baseMap * _BaseColor * shadowAmount;

                //菲涅尔
                half NdotV =max(0,dot(normal_dir,view_dir));
                half rimFactor =1 - saturate(pow(NdotV,_RimPower) * _RimScale);
                half3 rimColor = lerp(heightColor,_RimColor,rimFactor);
                
                return half4(rimColor,1.0);
            }

            ENDCG
        }
    }
}