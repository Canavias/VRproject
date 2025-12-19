// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Wall"
{
	Properties
	{
		_BaseTex("BaseTex", 2D) = "white" {}
		_Specular("Specular", 2D) = "white" {}
		[HDR]_BaseColor("BaseColor", Color) = (0,0,0,0)
		[HDR]_BaseColor1("BaseColor1", Color) = (0,0,0,0)
		_SpecularIntensity("SpecularIntensity", Float) = 0
		_BaseTexIntensity("BaseTexIntensity", Float) = 0
		_Normal("Normal", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		Stencil
		{
			Ref 0
			CompFront Always
			PassFront Replace
		}
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float4 _BaseColor;
		uniform float4 _BaseColor1;
		uniform sampler2D _BaseTex;
		SamplerState sampler_BaseTex;
		uniform float4 _BaseTex_ST;
		uniform float _BaseTexIntensity;
		uniform sampler2D _Specular;
		SamplerState sampler_Specular;
		uniform float4 _Specular_ST;
		uniform float _SpecularIntensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_BaseTex = i.uv_texcoord * _BaseTex_ST.xy + _BaseTex_ST.zw;
			float4 lerpResult12 = lerp( _BaseColor , _BaseColor1 , ( tex2D( _BaseTex, uv_BaseTex ).r * _BaseTexIntensity ));
			o.Albedo = lerpResult12.rgb;
			float2 uv_Specular = i.uv_texcoord * _Specular_ST.xy + _Specular_ST.zw;
			o.Smoothness = ( tex2D( _Specular, uv_Specular ).r * _SpecularIntensity );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
0;583.3334;856.3333;394.3333;987.1784;77.86827;2.592886;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-261.1539,-77.98226;Inherit;True;Property;_BaseTex;BaseTex;0;0;Create;True;0;0;False;0;False;-1;c92fda2388f47c24fad55f97a3251da7;c92fda2388f47c24fad55f97a3251da7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-26.40629,113.501;Inherit;False;Property;_BaseTexIntensity;BaseTexIntensity;5;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;169.1473,-30.95817;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;26.77051,-406.8207;Inherit;False;Property;_BaseColor;BaseColor;2;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;2.636272,2.636272,2.636272,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;13;23.4974,-213.8427;Inherit;False;Property;_BaseColor1;BaseColor1;3;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;2.390682,2.107918,1.871949,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-21.99608,541.7096;Inherit;True;Property;_Specular;Specular;1;0;Create;True;0;0;False;0;False;-1;0603004fec223b24ab6d4f87c2032166;0603004fec223b24ab6d4f87c2032166;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;41.35026,740.0326;Inherit;False;Property;_SpecularIntensity;SpecularIntensity;4;0;Create;True;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;12;374.6786,-230.7117;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;346.0171,562.6994;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;48.16907,259.384;Inherit;True;Property;_Normal;Normal;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;672.8539,-213.9397;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Wall;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;True;0;False;-1;255;False;-1;255;False;-1;7;False;-1;3;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;1;1
WireConnection;10;1;11;0
WireConnection;12;0;4;0
WireConnection;12;1;13;0
WireConnection;12;2;10;0
WireConnection;7;0;2;1
WireConnection;7;1;8;0
WireConnection;0;0;12;0
WireConnection;0;1;14;0
WireConnection;0;4;7;0
ASEEND*/
//CHKSM=359C46BB42426CAE4357E2C9D5A5E32B0DB556EF