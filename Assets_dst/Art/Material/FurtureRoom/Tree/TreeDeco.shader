// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TreeDeco"
{
	Properties
	{
		_TreeDeco_basecolor("TreeDeco_basecolor", 2D) = "white" {}
		_TreeDeco_metallic("TreeDeco_metallic", 2D) = "white" {}
		_TreeDeco_normal("TreeDeco_normal", 2D) = "white" {}
		_TreeDeco_roughness("TreeDeco_roughness", 2D) = "white" {}
		_BaseIntensity("BaseIntensity", Float) = 1
		_MetalIntensity("MetalIntensity", Range( 0 , 1)) = 0
		_SmoothnessIntensity("SmoothnessIntensity", Range( 0 , 1)) = 0
		_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_NormalIntensity("NormalIntensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
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
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _TreeDeco_normal;
		uniform float4 _TreeDeco_normal_ST;
		uniform float _NormalIntensity;
		uniform sampler2D _TreeDeco_basecolor;
		uniform float4 _TreeDeco_basecolor_ST;
		uniform float _BaseIntensity;
		uniform float4 _EmissionColor;
		uniform sampler2D _TreeDeco_metallic;
		SamplerState sampler_TreeDeco_metallic;
		uniform float4 _TreeDeco_metallic_ST;
		uniform float _MetalIntensity;
		uniform sampler2D _TreeDeco_roughness;
		SamplerState sampler_TreeDeco_roughness;
		uniform float4 _TreeDeco_roughness_ST;
		uniform float _SmoothnessIntensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TreeDeco_normal = i.uv_texcoord * _TreeDeco_normal_ST.xy + _TreeDeco_normal_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 lerpResult12 = lerp( tex2D( _TreeDeco_normal, uv_TreeDeco_normal ) , float4( ase_worldNormal , 0.0 ) , _NormalIntensity);
			o.Normal = lerpResult12.rgb;
			float2 uv_TreeDeco_basecolor = i.uv_texcoord * _TreeDeco_basecolor_ST.xy + _TreeDeco_basecolor_ST.zw;
			o.Albedo = ( tex2D( _TreeDeco_basecolor, uv_TreeDeco_basecolor ) * _BaseIntensity ).rgb;
			o.Emission = _EmissionColor.rgb;
			float2 uv_TreeDeco_metallic = i.uv_texcoord * _TreeDeco_metallic_ST.xy + _TreeDeco_metallic_ST.zw;
			o.Metallic = ( tex2D( _TreeDeco_metallic, uv_TreeDeco_metallic ).r * _MetalIntensity );
			float2 uv_TreeDeco_roughness = i.uv_texcoord * _TreeDeco_roughness_ST.xy + _TreeDeco_roughness_ST.zw;
			o.Smoothness = ( tex2D( _TreeDeco_roughness, uv_TreeDeco_roughness ).r * _SmoothnessIntensity );
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
7.333333;685.3334;1325.667;664.3334;2538.794;929.5648;2.956525;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-689.4485,-527.9484;Inherit;True;Property;_TreeDeco_basecolor;TreeDeco_basecolor;0;0;Create;True;0;0;False;0;False;-1;dfaabc8177bdfc347948c8951fcf4503;8b707f3d48139004d9a6597d54638b36;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-624.9674,-325.5826;Inherit;False;Property;_BaseIntensity;BaseIntensity;4;0;Create;True;0;0;False;0;False;1;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1367.063,-351.6241;Inherit;True;Property;_TreeDeco_normal;TreeDeco_normal;2;0;Create;True;0;0;False;0;False;-1;4122b325c5f2bcc45b7d8253f9d20267;426d86db1a751d84a8ace3e7a9db3592;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;13;-1293.496,-168.5602;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;14;-1256.829,-2.560211;Inherit;False;Property;_NormalIntensity;NormalIntensity;8;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1016.164,87.86694;Inherit;True;Property;_TreeDeco_metallic;TreeDeco_metallic;1;0;Create;True;0;0;False;0;False;-1;5d613c58652fe7a4cba39b6c68ed7572;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-1043.944,402.1737;Inherit;True;Property;_TreeDeco_roughness;TreeDeco_roughness;3;0;Create;True;0;0;False;0;False;-1;9d5403ef5eba2e7409a1527ab81f5aa7;33901df62fe4d69439319f1a82f313e7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-986.7223,604.2841;Inherit;False;Property;_SmoothnessIntensity;SmoothnessIntensity;6;0;Create;True;0;0;False;0;False;0;0.611;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1033.722,288.4171;Inherit;False;Property;_MetalIntensity;MetalIntensity;5;0;Create;True;0;0;False;0;False;0;0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-336.9674,-378.2493;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;12;-887.0775,-219.5993;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;7;-950.9352,-69.96471;Inherit;False;Property;_EmissionColor;EmissionColor;7;0;Create;True;0;0;False;0;False;0,0,0,0;0.04325368,0.3202594,0.509434,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-674.7222,148.4173;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-677.3223,404.9505;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;TreeDeco;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;1;0
WireConnection;5;1;6;0
WireConnection;12;0;3;0
WireConnection;12;1;13;0
WireConnection;12;2;14;0
WireConnection;8;0;2;1
WireConnection;8;1;9;0
WireConnection;10;0;4;1
WireConnection;10;1;11;0
WireConnection;0;0;5;0
WireConnection;0;1;12;0
WireConnection;0;2;7;0
WireConnection;0;3;8;0
WireConnection;0;4;10;0
ASEEND*/
//CHKSM=BD22FD592F2BA3B7B385EA9DE9995EFF0218C546