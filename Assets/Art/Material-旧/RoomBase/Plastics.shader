// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Seat/Plastics"
{
	Properties
	{
		_SmoothNoise("SmoothNoise", 2D) = "white" {}
		_CubeMap("CubeMap", CUBE) = "white" {}
		_MetalTelling("MetalTelling", Vector) = (1,1,1,0)
		_ReflectIntensity("ReflectIntensity", Float) = 1
		[HDR]_BaseColor("BaseColor", Color) = (0,0,0,0)
		_MetalOffset("MetalOffset", Vector) = (1,1,1,0)
		[HDR]_PlasticColor("PlasticColor", Color) = (0,0,0,0)
		_CubeLevel("CubeLevel", Float) = 1
		_Smoothness("Smoothness", Float) = 0
		_Metal("Metal", Float) = 0
		_EmissIntensity("EmissIntensity", Float) = 0
		_NoiseCaustic03("NoiseCaustic03", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		[Enum(UnityEngine.Rendering.CullMode)]_CullOff("CullOff", Float) = 0
		_NormalIntensity("NormalIntensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull [_CullOff]
		Stencil
		{
			Ref 1
			Comp Always
			Pass Replace
		}
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
			float3 worldRefl;
		};

		uniform float _CullOff;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _NormalIntensity;
		uniform float4 _BaseColor;
		uniform float4 _PlasticColor;
		uniform sampler2D _SmoothNoise;
		SamplerState sampler_SmoothNoise;
		uniform float4 _SmoothNoise_ST;
		uniform sampler2D _NoiseCaustic03;
		SamplerState sampler_NoiseCaustic03;
		uniform float4 _NoiseCaustic03_ST;
		uniform samplerCUBE _CubeMap;
		uniform float3 _MetalTelling;
		uniform float3 _MetalOffset;
		uniform float _CubeLevel;
		uniform float _ReflectIntensity;
		uniform float _EmissIntensity;
		uniform float _Metal;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 lerpResult42 = lerp( UnpackNormal( tex2D( _Normal, uv_Normal ) ) , ase_worldNormal , _NormalIntensity);
			o.Normal = lerpResult42;
			float2 uv_SmoothNoise = i.uv_texcoord * _SmoothNoise_ST.xy + _SmoothNoise_ST.zw;
			float2 uv_NoiseCaustic03 = i.uv_texcoord * _NoiseCaustic03_ST.xy + _NoiseCaustic03_ST.zw;
			float4 tex2DNode1 = tex2D( _SmoothNoise, ( uv_SmoothNoise + tex2D( _NoiseCaustic03, uv_NoiseCaustic03 ).r ) );
			float4 lerpResult19 = lerp( _BaseColor , _PlasticColor , tex2DNode1.r);
			float3 ase_worldReflection = WorldReflectionVector( i, float3( 0, 0, 1 ) );
			o.Albedo = ( lerpResult19 + ( texCUBElod( _CubeMap, float4( ( ( ase_worldReflection * _MetalTelling ) + _MetalOffset ), ( tex2DNode1.r * _CubeLevel )) ) * _ReflectIntensity ) ).rgb;
			o.Emission = ( lerpResult19 * _EmissIntensity ).rgb;
			o.Metallic = _Metal;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred 

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
				surfIN.worldRefl = -worldViewDir;
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
0;781.3334;1392.333;569.6667;4281.77;-199.7917;2.95872;True;False
Node;AmplifyShaderEditor.SamplerNode;37;-2506.369,282.5339;Inherit;True;Property;_NoiseCaustic03;NoiseCaustic03;11;0;Create;True;0;0;False;0;False;-1;7e57ec7eaa0e7164096f3ab848f35b65;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-2481.035,140.5339;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldReflectionVector;22;-1983.584,742.539;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;45;-1751.707,1022.498;Inherit;False;Property;_MetalTelling;MetalTelling;2;0;Create;True;0;0;False;0;False;1,1,1;1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-2162.369,177.2005;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-1938.989,140.1215;Inherit;True;Property;_SmoothNoise;SmoothNoise;0;0;Create;True;0;0;False;0;False;-1;1ea63dff1f8ab994db00dbc933577b9e;babd209fe2d65f54680039fa726c538d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;47;-1574.374,1046.498;Inherit;False;Property;_MetalOffset;MetalOffset;5;0;Create;True;0;0;False;0;False;1,1,1;1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-1582.374,899.8314;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1606.051,551.3391;Inherit;False;Property;_CubeLevel;CubeLevel;7;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1434.051,498.0057;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-1407.707,919.8315;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;11;-1136.303,405.9331;Inherit;True;Property;_CubeMap;CubeMap;1;0;Create;True;0;0;False;0;False;-1;3c3ab7209db960b4397b72902da353f9;93a647f2294de8a4ca93f7bc675faa24;True;0;False;white;LockedToCube;False;Object;-1;MipLevel;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;2;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-1050.065,641.4337;Inherit;False;Property;_ReflectIntensity;ReflectIntensity;3;0;Create;True;0;0;False;0;False;1;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-1071.233,-289.1143;Inherit;False;Property;_BaseColor;BaseColor;4;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0.1862268,0.2852557,0.553459,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;20;-1077.953,-114.2688;Inherit;False;Property;_PlasticColor;PlasticColor;6;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0.2299157,0.4285799,0.5849056,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;19;-656.3741,-77.87271;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-606.1017,118.7446;Inherit;False;Property;_EmissIntensity;EmissIntensity;10;0;Create;True;0;0;False;0;False;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;38;-432.1852,-558.0049;Inherit;True;Property;_Normal;Normal;12;0;Create;True;0;0;False;0;False;-1;None;f02730d15cf1ba143addaab60ac937a3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-788.7317,446.1003;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-349.9183,-154.8915;Inherit;False;Property;_NormalIntensity;NormalIntensity;14;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;44;-370.4344,-336.1687;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-359.0762,59.27955;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;42;-104.7957,-428.7737;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-398.3079,-92.73835;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-502.8219,-610.9897;Inherit;False;Property;_CullOff;CullOff;13;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-388.3679,287.2311;Inherit;False;Property;_Smoothness;Smoothness;8;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-390.0868,206.9928;Inherit;False;Property;_Metal;Metal;9;0;Create;True;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;10.20429,-91.83861;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Seat/Plastics;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;True;1;False;-1;255;False;-1;255;False;-1;7;False;-1;3;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;1;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;41;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;0;35;0
WireConnection;36;1;37;1
WireConnection;1;1;36;0
WireConnection;46;0;22;0
WireConnection;46;1;45;0
WireConnection;24;0;1;1
WireConnection;24;1;23;0
WireConnection;48;0;46;0
WireConnection;48;1;47;0
WireConnection;11;1;48;0
WireConnection;11;2;24;0
WireConnection;19;0;13;0
WireConnection;19;1;20;0
WireConnection;19;2;1;1
WireConnection;12;0;11;0
WireConnection;12;1;10;0
WireConnection;28;0;19;0
WireConnection;28;1;29;0
WireConnection;42;0;38;0
WireConnection;42;1;44;0
WireConnection;42;2;43;0
WireConnection;25;0;19;0
WireConnection;25;1;12;0
WireConnection;0;0;25;0
WireConnection;0;1;42;0
WireConnection;0;2;28;0
WireConnection;0;3;27;0
WireConnection;0;4;26;0
ASEEND*/
//CHKSM=D0854E2E9D5DD6CD61F162B800AA30B528186930