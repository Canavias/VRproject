// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Bed"
{
	Properties
	{
		_bad_disp("bad_disp", 2D) = "white" {}
		_Bed_color("Bed_color", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_AOintensity("AOintensity", Float) = 1
		_EmissIntensity("EmissIntensity", Float) = 1
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

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _bad_disp;
		uniform float4 _bad_disp_ST;
		uniform float _AOintensity;
		uniform sampler2D _Bed_color;
		uniform float4 _Bed_color_ST;
		uniform float _EmissIntensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_bad_disp = i.uv_texcoord * _bad_disp_ST.xy + _bad_disp_ST.zw;
			float4 tex2DNode1 = tex2D( _bad_disp, uv_bad_disp );
			float4 temp_output_4_0 = ( tex2DNode1 * _AOintensity );
			o.Albedo = temp_output_4_0.rgb;
			float2 uv_Bed_color = i.uv_texcoord * _Bed_color_ST.xy + _Bed_color_ST.zw;
			o.Emission = ( tex2D( _Bed_color, uv_Bed_color ) * _EmissIntensity ).rgb;
			o.Smoothness = tex2DNode1.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
0;781.3334;1392.333;569.6667;1209.858;-30.44226;1;True;False
Node;AmplifyShaderEditor.SamplerNode;2;-591.8683,288.5074;Inherit;True;Property;_Bed_color;Bed_color;1;0;Create;True;0;0;False;0;False;-1;ec8f7ef3749e2e54eac778e9176de4b5;ec8f7ef3749e2e54eac778e9176de4b5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-712.6193,-419.4124;Inherit;True;Property;_bad_disp;bad_disp;0;0;Create;True;0;0;False;0;False;-1;0b2c43d438f104044a8ddd70d978d1f4;0b2c43d438f104044a8ddd70d978d1f4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-629.388,-207.014;Inherit;False;Property;_AOintensity;AOintensity;3;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-490.7946,489.3683;Inherit;False;Property;_EmissIntensity;EmissIntensity;4;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-535.5037,-1.953632;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;False;0;False;-1;f05502e32e1dcf04b8b9902e2f3bcc68;f05502e32e1dcf04b8b9902e2f3bcc68;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-267.4611,333.3682;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-281.1289,-403.0983;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;76.40108,-65.48672;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Bed;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;2;0
WireConnection;7;1;6;0
WireConnection;4;0;1;0
WireConnection;4;1;5;0
WireConnection;0;0;4;0
WireConnection;0;1;3;0
WireConnection;0;2;7;0
WireConnection;0;4;1;1
ASEEND*/
//CHKSM=1398C1D0CE608267C491D1A42436839FC2621318