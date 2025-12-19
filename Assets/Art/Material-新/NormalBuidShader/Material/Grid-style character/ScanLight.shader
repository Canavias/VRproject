// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New/ScanLight"
{
	Properties
	{
		[Toggle]_ZWriteMode("ZWriteMode", Float) = 0
		[HDR]_MainColor("MainColor", Color) = (0,0,0,0)
		_RimBase("RimBase", Range( 0 , 1)) = 0
		_RimScale("RimScale", Float) = 1
		_RimPower("RimPower", Float) = 1
		_FlashNoiseTilling("FlashNoiseTilling", Float) = 100
		_FlashLerpControl("FlashLerpControl", Range( 0 , 1)) = 0.2555923
		_ScanLightTilling("ScanLightTilling", Float) = 1
		_ScanLightSpeed("ScanLightSpeed", Float) = 1
		_ScanLightTex("ScanLightTex", 2D) = "white" {}
		[HDR]_ScanLightColor("Scan LightColor", Color) = (0,0,0,0)
		_ScanLightAlpha("ScanLightAlpha", Range( 0 , 1)) = 0
		_ScanSub("ScanSub", Range( 0 , 1)) = 0
		_ScanScale("ScanScale", Float) = 1
		_LinnerTex("LinnerTex", 2D) = "white" {}
		_LinnerAlphaScale("LinnerAlphaScale", Range( 0 , 1)) = 0
		_Flashfrequency("Flashfrequency", Float) = 0
		_VertextOffset("VertextOffset", Vector) = (0,0,0,0)
		_GricthTilling("GricthTilling", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite [_ZWriteMode]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		uniform float _ZWriteMode;
		uniform float _GricthTilling;
		uniform float3 _VertextOffset;
		uniform sampler2D _ScanLightTex;
		SamplerState sampler_ScanLightTex;
		uniform float _ScanLightTilling;
		uniform float _ScanLightSpeed;
		uniform float _ScanSub;
		uniform float _ScanScale;
		uniform float _ScanLightAlpha;
		uniform float _FlashNoiseTilling;
		uniform float _Flashfrequency;
		uniform float _FlashLerpControl;
		uniform float _RimBase;
		uniform float _RimScale;
		uniform float _RimPower;
		uniform float4 _MainColor;
		uniform float4 _ScanLightColor;
		uniform sampler2D _LinnerTex;
		SamplerState sampler_LinnerTex;
		uniform float4 _LinnerTex_ST;
		uniform float _LinnerAlphaScale;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float mulTime87 = _Time.y * -2.5;
			float mulTime89 = _Time.y * -2.0;
			float2 appendResult88 = (float2((ase_worldPos.y*_GricthTilling + mulTime87) , mulTime89));
			float simplePerlin2D90 = snoise( appendResult88 );
			simplePerlin2D90 = simplePerlin2D90*0.5 + 0.5;
			float3 viewToObjDir97 = mul( UNITY_MATRIX_T_MV, float4( _VertextOffset, 0 ) ).xyz;
			float3 objToWorldDir56 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 0 ) ).xyz;
			float mulTime61 = _Time.y * _ScanLightSpeed;
			float2 appendResult63 = (float2(0.5 , ( ( ( ase_worldPos.y - objToWorldDir56.y ) * _ScanLightTilling ) + mulTime61 )));
			float clampResult72 = clamp( ( ( tex2Dlod( _ScanLightTex, float4( appendResult63, 0, 0.0) ).r - _ScanSub ) * _ScanScale ) , 0.0 , 1.0 );
			float ScanLightAlpha79 = ( clampResult72 * _ScanLightAlpha );
			float3 GritchVertextOffset94 = ( (simplePerlin2D90*2.0 + -1.0) * viewToObjDir97 * ( 1.0 - ScanLightAlpha79 ) );
			float3 objToWorld3 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float mulTime9 = _Time.y * _Flashfrequency;
			float mulTime10 = _Time.y * 0.5;
			float2 appendResult8 = (float2((( objToWorld3.x + objToWorld3.y + objToWorld3.z )*_FlashNoiseTilling + mulTime9) , mulTime10));
			float simplePerlin2D2 = snoise( appendResult8 );
			simplePerlin2D2 = simplePerlin2D2*0.5 + 0.5;
			float clampResult14 = clamp( (-0.5 + (simplePerlin2D2 - 0.0) * (2.0 - -0.5) / (1.0 - 0.0)) , 0.15 , 1.0 );
			float lerpResult53 = lerp( 1.0 , clampResult14 , _FlashLerpControl);
			float FlashNoise16 = lerpResult53;
			v.vertex.xyz += ( GritchVertextOffset94 * FlashNoise16 );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV30 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode30 = ( _RimBase + _RimScale * pow( 1.0 - fresnelNdotV30, _RimPower ) );
			float clampResult50 = clamp( fresnelNode30 , 0.0 , 1.0 );
			float FresnelFactor38 = clampResult50;
			float3 objToWorldDir56 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 0 ) ).xyz;
			float mulTime61 = _Time.y * _ScanLightSpeed;
			float2 appendResult63 = (float2(0.5 , ( ( ( ase_worldPos.y - objToWorldDir56.y ) * _ScanLightTilling ) + mulTime61 )));
			float clampResult72 = clamp( ( ( tex2D( _ScanLightTex, appendResult63 ).r - _ScanSub ) * _ScanScale ) , 0.0 , 1.0 );
			float4 ScanLightColor65 = ( clampResult72 * _ScanLightColor );
			float3 objToWorld3 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float mulTime9 = _Time.y * _Flashfrequency;
			float mulTime10 = _Time.y * 0.5;
			float2 appendResult8 = (float2((( objToWorld3.x + objToWorld3.y + objToWorld3.z )*_FlashNoiseTilling + mulTime9) , mulTime10));
			float simplePerlin2D2 = snoise( appendResult8 );
			simplePerlin2D2 = simplePerlin2D2*0.5 + 0.5;
			float clampResult14 = clamp( (-0.5 + (simplePerlin2D2 - 0.0) * (2.0 - -0.5) / (1.0 - 0.0)) , 0.15 , 1.0 );
			float lerpResult53 = lerp( 1.0 , clampResult14 , _FlashLerpControl);
			float FlashNoise16 = lerpResult53;
			o.Emission = ( ( ( FresnelFactor38 * _MainColor ) + _MainColor + ScanLightColor65 ) * FlashNoise16 ).rgb;
			float ScanLightAlpha79 = ( clampResult72 * _ScanLightAlpha );
			float clampResult44 = clamp( ( _MainColor.a + FresnelFactor38 + ScanLightAlpha79 ) , 0.0 , 1.0 );
			float2 uv_LinnerTex = i.uv_texcoord * _LinnerTex_ST.xy + _LinnerTex_ST.zw;
			float LinnerColor28 = ( 1.0 - tex2D( _LinnerTex, uv_LinnerTex ).r );
			o.Alpha = ( clampResult44 * LinnerColor28 * _LinnerAlphaScale );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
0;583.3334;856.3333;394.3333;3521.372;806.1553;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;66;-3218.296,308.4374;Inherit;False;2265.142;492.3893;;21;65;76;75;71;69;68;70;72;63;64;60;61;58;57;59;62;56;55;77;78;79;扫光效果;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;55;-3127.483,358.4374;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformDirectionNode;56;-3168.296,538.3848;Inherit;False;Object;World;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;62;-2944.296,675.0513;Inherit;False;Property;_ScanLightSpeed;ScanLightSpeed;9;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;57;-2923.629,465.0518;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-2930.963,561.0513;Inherit;False;Property;_ScanLightTilling;ScanLightTilling;8;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-2750.296,466.3851;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;61;-2717.63,641.0515;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-2542.963,475.7182;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;63;-2411.15,403.933;Inherit;False;FLOAT2;4;0;FLOAT;0.5;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;64;-2256.51,355.7472;Inherit;True;Property;_ScanLightTex;ScanLightTex;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;-2398.591,543.4097;Inherit;False;Property;_ScanSub;ScanSub;13;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;15;-3290.075,-859.4222;Inherit;False;1950.597;434.8949;;14;16;53;14;51;13;2;8;10;5;6;9;4;3;83;闪烁效果实现;1,0,0,1;0;0
Node;AmplifyShaderEditor.TransformPositionNode;3;-3145.408,-809.4222;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;68;-1941.153,390.2893;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2076.67,556.4757;Inherit;False;Property;_ScanScale;ScanScale;14;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-3204.584,-567.1318;Inherit;False;Property;_Flashfrequency;Flashfrequency;17;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-3004.269,-587.5195;Inherit;False;1;0;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-2928.074,-784.7557;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1778.593,390.1823;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-3052.336,-665.9192;Inherit;False;Property;_FlashNoiseTilling;FlashNoiseTilling;6;0;Create;True;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;95;-3228.472,820.3751;Inherit;False;1680.916;433.6254;;14;84;86;85;88;87;89;90;91;92;93;94;97;100;101;毛刺偏移效果;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;5;-2786.271,-745.8152;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;36;-3213.741,-111.8721;Inherit;False;974.2679;412.3693;;6;38;50;30;32;33;34;边缘光;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-2766.938,-531.8151;Inherit;False;1;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;87;-3154.472,1082.376;Inherit;False;1;0;FLOAT;-2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;72;-1632.113,364.263;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-3169.139,1004.376;Inherit;False;Property;_GricthTilling;GricthTilling;19;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-1725.821,674.8033;Inherit;False;Property;_ScanLightAlpha;ScanLightAlpha;12;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;84;-3178.472,870.3751;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;86;-2902.472,905.7084;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-3193.387,94.30946;Inherit;False;Property;_RimBase;RimBase;3;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-2562.656,-736.3891;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;89;-2862.472,1059.042;Inherit;False;1;0;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-3082.72,170.9762;Inherit;False;Property;_RimScale;RimScale;4;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-3092.054,240.9762;Inherit;False;Property;_RimPower;RimPower;5;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-1394.487,582.8032;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;32;-3105.387,-43.02387;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NoiseGeneratorNode;2;-2425.995,-742.1024;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;88;-2605.805,917.0417;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;30;-2853.387,21.64279;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-1212.487,583.9349;Inherit;False;ScanLightAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;13;-2235.199,-789.8528;Inherit;False;258.77;252.8;将数据重新映射到-0.5 - 2;1;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-2400.22,1183.542;Inherit;False;79;ScanLightAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;27;-3199.916,-424.0791;Inherit;False;911.6365;303.7348;;3;28;21;26;LinnerColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;75;-1688.344,467.059;Inherit;False;Property;_ScanLightColor;Scan LightColor;11;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;11;-2185.2,-739.8528;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;50;-2615.467,22.07377;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;93;-2607.196,1043.545;Inherit;False;Property;_VertextOffset;VertextOffset;18;0;Create;True;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NoiseGeneratorNode;90;-2436.563,915.3605;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1433.82,372.1367;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;14;-1974.757,-765.1698;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;91;-2220.563,918.0271;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;-2461.254,26.09548;Inherit;False;FresnelFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-3120.05,-342.0791;Inherit;True;Property;_LinnerTex;LinnerTex;15;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;51;-1947.977,-598.076;Inherit;False;Property;_FlashLerpControl;FlashLerpControl;7;0;Create;True;0;0;False;0;False;0.2555923;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;97;-2383.986,1033.301;Inherit;False;View;Object;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;101;-2163.06,1180.944;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-1149.556,-34.76902;Inherit;False;Property;_MainColor;MainColor;2;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;53;-1751.962,-751.7865;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-1983.229,920.6938;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-933.9829,-214.7511;Inherit;False;38;FresnelFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-591.6722,194.5943;Inherit;False;38;FresnelFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-600.2874,286.7392;Inherit;False;79;ScanLightAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-1265.632,377.0517;Inherit;False;ScanLightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;26;-2785.326,-306.8698;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-295.3829,119.5554;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1591.681,-745.4521;Inherit;False;FlashNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-786.9686,-37.88521;Inherit;False;65;ScanLightColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-2552.431,-344.1019;Inherit;False;LinnerColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-684.8625,-192.8816;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-1808.824,925.461;Inherit;False;GritchVertextOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-500.4065,-171.8148;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-259.8148,409.1297;Inherit;False;94;GritchVertextOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-315.1556,319.2559;Inherit;False;Property;_LinnerAlphaScale;LinnerAlphaScale;16;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-508.054,-47.30674;Inherit;False;16;FlashNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;44;-163.9537,117.4433;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-252.4085,244.3914;Inherit;False;28;LinnerColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-212.7337,492.4686;Inherit;False;16;FlashNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;24.25821,111.058;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;16.16919,372.6089;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-246.0157,-97.47851;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;20;178.1588,-131.2494;Inherit;False;Property;_ZWriteMode;ZWriteMode;1;1;[Toggle];Create;True;0;1;;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;304.2775,-65.69279;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;New/ScanLight;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;2;True;20;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;57;0;55;2
WireConnection;57;1;56;2
WireConnection;58;0;57;0
WireConnection;58;1;59;0
WireConnection;61;0;62;0
WireConnection;60;0;58;0
WireConnection;60;1;61;0
WireConnection;63;1;60;0
WireConnection;64;1;63;0
WireConnection;68;0;64;1
WireConnection;68;1;69;0
WireConnection;9;0;83;0
WireConnection;4;0;3;1
WireConnection;4;1;3;2
WireConnection;4;2;3;3
WireConnection;70;0;68;0
WireConnection;70;1;71;0
WireConnection;5;0;4;0
WireConnection;5;1;6;0
WireConnection;5;2;9;0
WireConnection;72;0;70;0
WireConnection;86;0;84;2
WireConnection;86;1;85;0
WireConnection;86;2;87;0
WireConnection;8;0;5;0
WireConnection;8;1;10;0
WireConnection;77;0;72;0
WireConnection;77;1;78;0
WireConnection;2;0;8;0
WireConnection;88;0;86;0
WireConnection;88;1;89;0
WireConnection;30;0;32;0
WireConnection;30;1;33;0
WireConnection;30;2;34;0
WireConnection;30;3;35;0
WireConnection;79;0;77;0
WireConnection;11;0;2;0
WireConnection;50;0;30;0
WireConnection;90;0;88;0
WireConnection;76;0;72;0
WireConnection;76;1;75;0
WireConnection;14;0;11;0
WireConnection;91;0;90;0
WireConnection;38;0;50;0
WireConnection;97;0;93;0
WireConnection;101;0;100;0
WireConnection;53;1;14;0
WireConnection;53;2;51;0
WireConnection;92;0;91;0
WireConnection;92;1;97;0
WireConnection;92;2;101;0
WireConnection;65;0;76;0
WireConnection;26;0;21;1
WireConnection;81;0;1;4
WireConnection;81;1;41;0
WireConnection;81;2;67;0
WireConnection;16;0;53;0
WireConnection;28;0;26;0
WireConnection;25;0;49;0
WireConnection;25;1;1;0
WireConnection;94;0;92;0
WireConnection;22;0;25;0
WireConnection;22;1;1;0
WireConnection;22;2;80;0
WireConnection;44;0;81;0
WireConnection;47;0;44;0
WireConnection;47;1;48;0
WireConnection;47;2;82;0
WireConnection;103;0;96;0
WireConnection;103;1;104;0
WireConnection;18;0;22;0
WireConnection;18;1;17;0
WireConnection;0;2;18;0
WireConnection;0;9;47;0
WireConnection;0;11;103;0
ASEEND*/
//CHKSM=9FEDCC3564C6FDE9BBA80A47B3396C7503097035