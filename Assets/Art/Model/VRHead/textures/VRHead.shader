// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VRHead"
{
	Properties
	{
		_Image_0("Image_0", 2D) = "white" {}
		_BaseColor("BaseColor", 2D) = "white" {}
		_BaseIntensity("BaseIntensity", Float) = 1
		_EmissIntensity("EmissIntensity", Float) = 1
		_AddEmissColor("AddEmissColor", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BaseColor;
		uniform float4 _BaseColor_ST;
		uniform float _BaseIntensity;
		uniform float _EmissIntensity;
		uniform float4 _AddEmissColor;
		uniform sampler2D _Image_0;
		SamplerState sampler_Image_0;
		uniform float4 _Image_0_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BaseColor = i.uv_texcoord * _BaseColor_ST.xy + _BaseColor_ST.zw;
			float4 tex2DNode2 = tex2D( _BaseColor, uv_BaseColor );
			o.Albedo = ( tex2DNode2 * _BaseIntensity ).rgb;
			o.Emission = ( ( _EmissIntensity * tex2DNode2 ) + _AddEmissColor ).rgb;
			float2 uv_Image_0 = i.uv_texcoord * _Image_0_ST.xy + _Image_0_ST.zw;
			float4 tex2DNode1 = tex2D( _Image_0, uv_Image_0 );
			o.Metallic = tex2DNode1.b;
			o.Smoothness = ( 1.0 - tex2DNode1.g );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
0;503.3333;866.3333;474.3333;874.6104;71.11174;1;True;False
Node;AmplifyShaderEditor.SamplerNode;2;-1113.557,-70.83675;Inherit;True;Property;_BaseColor;BaseColor;1;0;Create;True;0;0;False;0;False;-1;0034877506a679d4dadea46c5dfc7a61;0034877506a679d4dadea46c5dfc7a61;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;8;-553.1202,78.75404;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-643.0403,-64.72131;Inherit;False;Property;_EmissIntensity;EmissIntensity;3;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;7;-673.0179,-270.7004;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-638.7469,-210.6168;Inherit;False;Property;_BaseIntensity;BaseIntensity;2;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-444.9358,39.91496;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-519.7335,337.3808;Inherit;True;Property;_Image_0;Image_0;0;0;Create;True;0;0;False;0;False;-1;1ebb3733337d5944496e8c986c7f2505;0034877506a679d4dadea46c5dfc7a61;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;12;-471.9436,134.8883;Inherit;False;Property;_AddEmissColor;AddEmissColor;4;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-412.7142,-336.6058;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-215.7482,49.84909;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;3;-232.386,389.7116;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;VRHead;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;2;0
WireConnection;7;0;2;0
WireConnection;9;0;10;0
WireConnection;9;1;8;0
WireConnection;4;0;7;0
WireConnection;4;1;5;0
WireConnection;11;0;9;0
WireConnection;11;1;12;0
WireConnection;3;0;1;2
WireConnection;0;0;4;0
WireConnection;0;2;11;0
WireConnection;0;3;1;3
WireConnection;0;4;3;0
ASEEND*/
//CHKSM=4EA62D4DAF891520477834EFAAA1F73605C6C98B