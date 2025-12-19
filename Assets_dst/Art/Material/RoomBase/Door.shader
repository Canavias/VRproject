// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Door"
{
	Properties
	{
		_DoorTex("DoorTex", 2D) = "white" {}
		_DoorColor("DoorColor", Color) = (0,0,0,0)
		_DoorColor1("DoorColor1", Color) = (0,0,0,0)
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_NoiseIntensity("NoiseIntensity", Float) = 1
		_BaseTexIntensity("BaseTexIntensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _DoorColor;
		uniform float4 _DoorColor1;
		uniform sampler2D _DoorTex;
		SamplerState sampler_DoorTex;
		uniform float4 _DoorTex_ST;
		uniform sampler2D _NoiseTex;
		SamplerState sampler_NoiseTex;
		uniform float4 _NoiseTex_ST;
		uniform float _NoiseIntensity;
		uniform float _BaseTexIntensity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_DoorTex = i.uv_texcoord * _DoorTex_ST.xy + _DoorTex_ST.zw;
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float4 tex2DNode7 = tex2D( _NoiseTex, uv_NoiseTex );
			float2 appendResult11 = (float2(tex2DNode7.r , tex2DNode7.g));
			o.Emission = ( _DoorColor + ( _DoorColor1 * ( ( 1.0 - tex2D( _DoorTex, ( uv_DoorTex + ( appendResult11 * _NoiseIntensity ) ) ).r ) * _BaseTexIntensity ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
40.66667;975.3334;1296.333;353.6667;1095.236;347.8063;1;True;False
Node;AmplifyShaderEditor.SamplerNode;7;-1841.942,95.50196;Inherit;True;Property;_NoiseTex;NoiseTex;3;0;Create;True;0;0;False;0;False;-1;87aa55e4c3c29db4bbb4ad9a788d57c8;87aa55e4c3c29db4bbb4ad9a788d57c8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;11;-1526.326,99.77366;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1550.374,216.5795;Inherit;False;Property;_NoiseIntensity;NoiseIntensity;4;0;Create;True;0;0;False;0;False;1;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1353.178,66.10603;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1530.479,-115.1386;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1214.479,-59.80527;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-910.0198,-218.7059;Inherit;True;Property;_DoorTex;DoorTex;0;0;Create;True;0;0;False;0;False;-1;8a0127747d3504c4e98f86eb0a770f5f;8a0127747d3504c4e98f86eb0a770f5f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-580.9945,-78.5397;Inherit;False;Property;_BaseTexIntensity;BaseTexIntensity;5;0;Create;True;0;0;False;0;False;0;3.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;23;-572.5689,-177.1396;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-358.3381,-193.5189;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-424.3364,-410.7237;Inherit;False;Property;_DoorColor1;DoorColor1;2;0;Create;True;0;0;False;0;False;0,0,0,0;0.6037736,0.4888248,0.4537794,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-244.0537,-675.2207;Inherit;False;Property;_DoorColor;DoorColor;1;0;Create;True;0;0;False;0;False;0,0,0,0;0.2830189,0.08631144,0.02936985,0.2392157;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-80.0089,-291.871;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;118.323,-451.1492;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;329.524,-392.5369;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Door;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;7;1
WireConnection;11;1;7;2
WireConnection;12;0;11;0
WireConnection;12;1;13;0
WireConnection;9;0;8;0
WireConnection;9;1;12;0
WireConnection;2;1;9;0
WireConnection;23;0;2;1
WireConnection;15;0;23;0
WireConnection;15;1;16;0
WireConnection;22;0;20;0
WireConnection;22;1;15;0
WireConnection;21;0;5;0
WireConnection;21;1;22;0
WireConnection;0;2;21;0
ASEEND*/
//CHKSM=F88680683B72F88822171934118835BCB7E862E5