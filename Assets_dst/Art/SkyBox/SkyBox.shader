// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SkyBox"
{
	Properties
	{
		_Cube1("Cube1", CUBE) = "white" {}
		_Rotation("Rotation", Range( 0 , 360)) = 0
		_EmissionInensity("EmissionInensity", Float) = 1
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		_Cube2("Cube2", CUBE) = "white" {}
		_CUbeChange("CUbeChange", Range( 0 , 1)) = 0
		_Scale("Scale", Range( 0 , 2)) = 0
		_NoiseCaustic02("NoiseCaustic02", 2D) = "white" {}
		_NoiseTillingAndOffset("NoiseTillingAndOffset", Vector) = (1,1,0,0)
		_NoiseSpread("NoiseSpread", Float) = 1
		_NoiseEdgeControl("NoiseEdgeControl", Float) = 2
		_EdgeRamp("EdgeRamp", 2D) = "white" {}
		_EdgeColor("EdgeColor", Color) = (0,0.3581009,1,0)
		_EdgeIntensity("EdgeIntensity", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 viewDir;
			float2 uv_texcoord;
		};

		uniform samplerCUBE _Cube1;
		uniform float _Rotation;
		uniform float _Scale;
		uniform samplerCUBE _Cube2;
		uniform float _CUbeChange;
		uniform float _NoiseEdgeControl;
		uniform sampler2D _NoiseCaustic02;
		SamplerState sampler_NoiseCaustic02;
		uniform float4 _NoiseTillingAndOffset;
		uniform float _NoiseSpread;
		uniform float _EmissionInensity;
		uniform float4 _BaseColor;
		uniform float _EdgeIntensity;
		uniform float4 _EdgeColor;
		uniform sampler2D _EdgeRamp;
		SamplerState sampler_EdgeRamp;


		float2 MyCustomExpression15( float2 reflect_dir, float degree )
		{
			 float rad = degree*UNITY_PI/180;
			                float2x2 m_rotate = float2x2(cos(rad), -sin(rad),
			                                            sin(rad),cos(rad));
			                float2 dir_rotate = mul(m_rotate,reflect_dir);
			                return dir_rotate;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult8 = (float2(i.viewDir.x , i.viewDir.z));
			float2 reflect_dir15 = appendResult8;
			float degree15 = _Rotation;
			float2 localMyCustomExpression15 = MyCustomExpression15( reflect_dir15 , degree15 );
			float2 break16 = localMyCustomExpression15;
			float3 appendResult4 = (float3(break16.x , ( -i.viewDir.y * _Scale ) , break16.y));
			float4 BaseCubeMap60 = texCUBE( _Cube1, appendResult4 );
			float4 ChangeCubeMap69 = texCUBE( _Cube2, appendResult4 );
			float clampResult97 = clamp( ( (_CUbeChange*3.0 + -1.0) - i.uv_texcoord.y ) , 0.0 , 1.0 );
			float2 temp_output_78_0 = ( i.uv_texcoord * (_NoiseTillingAndOffset).xy );
			float2 temp_output_86_0 = ( (_NoiseTillingAndOffset).zw * _Time.y );
			float clampResult102 = clamp( ( ( clampResult97 * _NoiseEdgeControl ) - ( ( ( tex2D( _NoiseCaustic02, ( temp_output_78_0 + temp_output_86_0 ) ).r + tex2D( _NoiseCaustic02, ( ( temp_output_86_0 * 1.5 ) + ( temp_output_78_0 * 0.8 ) ) ).r ) * 0.5 ) / _NoiseSpread ) ) , 0.0 , 1.0 );
			float Noise93 = clampResult102;
			float4 lerpResult94 = lerp( BaseCubeMap60 , ChangeCubeMap69 , Noise93);
			float4 temp_output_18_0 = ( lerpResult94 * _EmissionInensity );
			float2 appendResult106 = (float2(clampResult102 , 0.0));
			float EdgeControl108 = tex2D( _EdgeRamp, appendResult106 ).r;
			o.Emission = ( ( temp_output_18_0 + ( temp_output_18_0 * _BaseColor ) ) + ( _EdgeIntensity * ( _EdgeColor * EdgeControl108 ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
0;578;901.6667;399.6667;2259.917;237.8497;3.657631;True;False
Node;AmplifyShaderEditor.CommentaryNode;67;-3567.93,-799.2796;Inherit;False;2199.666;1164.969;;32;97;98;99;95;24;83;89;81;77;84;28;92;82;86;88;87;90;80;85;78;91;79;100;101;102;103;104;105;106;93;107;108;ChangeCubeMapFator;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;80;-3511.316,-495.7552;Inherit;False;Property;_NoiseTillingAndOffset;NoiseTillingAndOffset;8;0;Create;True;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;82;-3283.31,-456.4777;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;87;-3296.621,-348.4721;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;81;-3286.809,-530.961;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-3475.99,-645.1869;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;89;-3276.363,-275.4194;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-3069.5,-540.3674;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-3177.443,-636.283;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-3276.182,-182.6615;Inherit;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-3061.316,-250.4859;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-2987.558,-374.3367;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-2853.407,-290.5636;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;59;-3895.143,416.7767;Inherit;False;2050.642;493.557;;13;1;4;25;16;15;7;26;2;8;3;60;22;69;BaseCubeMap;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-2938.142,-628.2943;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-3268.542,-13.14846;Inherit;False;Property;_CUbeChange;CUbeChange;5;0;Create;True;0;0;False;0;False;0;-1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;99;-2994.232,-10.54299;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;3;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;90;-2727.121,-410.6366;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;False;-1;87aa55e4c3c29db4bbb4ad9a788d57c8;87aa55e4c3c29db4bbb4ad9a788d57c8;True;0;False;white;Auto;False;Instance;77;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;77;-2719.949,-675.6162;Inherit;True;Property;_NoiseCaustic02;NoiseCaustic02;7;0;Create;True;0;0;False;0;False;-1;87aa55e4c3c29db4bbb4ad9a788d57c8;87aa55e4c3c29db4bbb4ad9a788d57c8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;3;-3845.143,503.9325;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;95;-3078.156,158.7567;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;8;-3466.289,621.6841;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-3607.734,735.9835;Inherit;False;Property;_Rotation;Rotation;1;0;Create;True;0;0;False;0;False;0;100;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;98;-2781.607,23.70764;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-2430.696,-521.4496;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-2608.723,89.35694;Inherit;False;Property;_NoiseEdgeControl;NoiseEdgeControl;10;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-2368.734,-409.511;Inherit;False;Property;_NoiseSpread;NoiseSpread;9;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-3393.484,562.0481;Inherit;False;Property;_Scale;Scale;6;0;Create;True;0;0;False;0;False;0;1.3;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-2332.461,-747.7528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;7;-3365.168,466.7767;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;15;-3306.841,678.7374;Inherit;False; float rad = degree*UNITY_PI/180@$                float2x2 m_rotate = float2x2(cos(rad), -sin(rad),$                                            sin(rad),cos(rad))@$                float2 dir_rotate = mul(m_rotate,reflect_dir)@$                return dir_rotate@;2;False;2;True;reflect_dir;FLOAT2;0,0;In;;Inherit;False;True;degree;FLOAT;0;In;;Inherit;False;My Custom Expression;True;False;0;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;97;-2596.346,-48.01759;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-3005.232,553.2306;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-2374.978,-29.32982;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;104;-2175.947,-731.886;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;16;-3111.223,679.7059;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleSubtractOpNode;101;-1983.2,-699.1911;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;4;-2829.422,569.4362;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;102;-2076.385,-352.8519;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-2523.384,449.5235;Inherit;True;Property;_Cube1;Cube1;0;0;Create;True;0;0;False;0;False;-1;None;bb7913869f07530429804095e6cd3c45;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-2644.056,709.556;Inherit;True;Property;_Cube2;Cube2;4;0;Create;True;0;0;False;0;False;-1;273ebef52dedcf047944eaddd5233a26;6dc050e2e15a7444780e70d322836027;True;0;False;white;Auto;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-2261.567,718.7009;Inherit;False;ChangeCubeMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-1566.094,-450.2056;Inherit;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-2143.549,506.7683;Inherit;False;BaseCubeMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;106;-2115.275,40.82342;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-866.6927,-107.1162;Inherit;False;60;BaseCubeMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-885.5724,-9.674498;Inherit;False;69;ChangeCubeMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;107;-1951.379,20.85945;Inherit;True;Property;_EdgeRamp;EdgeRamp;11;0;Create;True;0;0;False;0;False;-1;588009d02aa79a64b93ee3c0be5fe5dd;588009d02aa79a64b93ee3c0be5fe5dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;65;-879.6533,95.56623;Inherit;False;93;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-573.8804,104.1913;Inherit;False;Property;_EmissionInensity;EmissionInensity;2;0;Create;True;0;0;False;0;False;1;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;94;-594.4721,-43.02872;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-1621.738,37.09003;Inherit;False;EdgeControl;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-418.1823,263.3557;Inherit;False;Property;_BaseColor;BaseColor;3;0;Create;True;0;0;False;0;False;0,0,0,0;0.4716981,0.3595927,0.2773822,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-302.2222,-38.67775;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;-174.368,617.9014;Inherit;False;108;EdgeControl;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;110;-175.321,432.0886;Inherit;False;Property;_EdgeColor;EdgeColor;12;0;Create;True;0;0;False;0;False;0,0.3581009,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;114;74.32581,287.4294;Inherit;False;Property;_EdgeIntensity;EdgeIntensity;13;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-134.5905,58.79258;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;81.00552,409.2194;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;61.15219,-23.16031;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;255.4331,316.3224;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;290.305,-11.45314;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;526.1243,-78.17477;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SkyBox;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;82;0;80;0
WireConnection;81;0;80;0
WireConnection;86;0;82;0
WireConnection;86;1;87;0
WireConnection;78;0;28;0
WireConnection;78;1;81;0
WireConnection;83;0;78;0
WireConnection;83;1;84;0
WireConnection;88;0;86;0
WireConnection;88;1;89;0
WireConnection;85;0;88;0
WireConnection;85;1;83;0
WireConnection;79;0;78;0
WireConnection;79;1;86;0
WireConnection;99;0;24;0
WireConnection;90;1;85;0
WireConnection;77;1;79;0
WireConnection;8;0;3;1
WireConnection;8;1;3;3
WireConnection;98;0;99;0
WireConnection;98;1;95;2
WireConnection;91;0;77;1
WireConnection;91;1;90;1
WireConnection;92;0;91;0
WireConnection;7;0;3;2
WireConnection;15;0;8;0
WireConnection;15;1;2;0
WireConnection;97;0;98;0
WireConnection;25;0;7;0
WireConnection;25;1;26;0
WireConnection;100;0;97;0
WireConnection;100;1;105;0
WireConnection;104;0;92;0
WireConnection;104;1;103;0
WireConnection;16;0;15;0
WireConnection;101;0;100;0
WireConnection;101;1;104;0
WireConnection;4;0;16;0
WireConnection;4;1;25;0
WireConnection;4;2;16;1
WireConnection;102;0;101;0
WireConnection;1;1;4;0
WireConnection;22;1;4;0
WireConnection;69;0;22;0
WireConnection;93;0;102;0
WireConnection;60;0;1;0
WireConnection;106;0;102;0
WireConnection;107;1;106;0
WireConnection;94;0;61;0
WireConnection;94;1;71;0
WireConnection;94;2;65;0
WireConnection;108;0;107;1
WireConnection;18;0;94;0
WireConnection;18;1;17;0
WireConnection;19;0;18;0
WireConnection;19;1;20;0
WireConnection;111;0;110;0
WireConnection;111;1;112;0
WireConnection;21;0;18;0
WireConnection;21;1;19;0
WireConnection;113;0;114;0
WireConnection;113;1;111;0
WireConnection;109;0;21;0
WireConnection;109;1;113;0
WireConnection;0;2;109;0
ASEEND*/
//CHKSM=61B4395DA0C5D29069A0F582553FCBB2C82A33E6