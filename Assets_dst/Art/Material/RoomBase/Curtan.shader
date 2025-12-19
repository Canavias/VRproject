// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Seat/Curtan"
{
	Properties
	{
		_Fabric_Line1_diffuse4k("Fabric_Line 1_diffuse 4k", 2D) = "white" {}
		_Fabric_Line1_FallOff4k("Fabric_Line 1_FallOff 4k", 2D) = "white" {}
		_Fabric_Line1_normal4k("Fabric_Line 1_normal 4k", 2D) = "white" {}
		_NormalIntensity("NormalIntensity", Float) = 1
		_BaseIntensity("BaseIntensity", Float) = 1
		_EmissIntensity("EmissIntensity", Float) = 1
		_AddColorIntensity("AddColorIntensity", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Stencil
		{
			Ref 1
			Comp Always
			Pass Replace
		}
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Fabric_Line1_normal4k;
		uniform float4 _Fabric_Line1_normal4k_ST;
		uniform float _NormalIntensity;
		uniform float _AddColorIntensity;
		uniform sampler2D _Fabric_Line1_FallOff4k;
		uniform float4 _Fabric_Line1_FallOff4k_ST;
		uniform float _BaseIntensity;
		uniform sampler2D _Fabric_Line1_diffuse4k;
		uniform float4 _Fabric_Line1_diffuse4k_ST;
		uniform float _EmissIntensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Fabric_Line1_normal4k = i.uv_texcoord * _Fabric_Line1_normal4k_ST.xy + _Fabric_Line1_normal4k_ST.zw;
			o.Normal = ( UnpackNormal( tex2D( _Fabric_Line1_normal4k, uv_Fabric_Line1_normal4k ) ) * _NormalIntensity );
			float2 uv_Fabric_Line1_FallOff4k = i.uv_texcoord * _Fabric_Line1_FallOff4k_ST.xy + _Fabric_Line1_FallOff4k_ST.zw;
			float2 uv_Fabric_Line1_diffuse4k = i.uv_texcoord * _Fabric_Line1_diffuse4k_ST.xy + _Fabric_Line1_diffuse4k_ST.zw;
			float4 tex2DNode7 = tex2D( _Fabric_Line1_diffuse4k, uv_Fabric_Line1_diffuse4k );
			o.Albedo = ( ( _AddColorIntensity * tex2D( _Fabric_Line1_FallOff4k, uv_Fabric_Line1_FallOff4k ) ) + ( _BaseIntensity * tex2DNode7 ) ).rgb;
			o.Emission = ( tex2DNode7 * _EmissIntensity ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
0;844.6667;1425;506.3334;2634.864;701.0651;2.286588;True;False
Node;AmplifyShaderEditor.SamplerNode;7;-1000.643,114.1088;Inherit;True;Property;_Fabric_Line1_diffuse4k;Fabric_Line 1_diffuse 4k;0;0;Create;True;0;0;False;0;False;-1;18dfd43608695254a841035d4820b40c;18dfd43608695254a841035d4820b40c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-782.7759,-27.54185;Inherit;False;Property;_BaseIntensity;BaseIntensity;4;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-700.6498,-419.7713;Inherit;False;Property;_AddColorIntensity;AddColorIntensity;6;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-744.2048,-333.0329;Inherit;True;Property;_Fabric_Line1_FallOff4k;Fabric_Line 1_FallOff 4k;1;0;Create;True;0;0;False;0;False;-1;6a0e00aa3f9eec74ab23201efece9d98;6a0e00aa3f9eec74ab23201efece9d98;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-591.1755,30.10273;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-638.9943,325.6751;Inherit;False;Property;_EmissIntensity;EmissIntensity;5;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1275.913,-91.40116;Inherit;False;Property;_NormalIntensity;NormalIntensity;3;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-1361.934,-279.2888;Inherit;True;Property;_Fabric_Line1_normal4k;Fabric_Line 1_normal 4k;2;0;Create;True;0;0;False;0;False;-1;98b760e082e251c4196bdf7fdf8fe94e;98b760e082e251c4196bdf7fdf8fe94e;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-376.2487,-317.597;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-405.7716,256.6793;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1020.519,-124.8248;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-284.4867,-5.610896;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Seat/Curtan;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;True;1;False;-1;255;False;-1;255;False;-1;7;False;-1;3;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;0;13;0
WireConnection;14;1;7;0
WireConnection;19;0;20;0
WireConnection;19;1;8;0
WireConnection;16;0;7;0
WireConnection;16;1;15;0
WireConnection;12;0;9;0
WireConnection;12;1;11;0
WireConnection;18;0;19;0
WireConnection;18;1;14;0
WireConnection;2;0;18;0
WireConnection;2;1;12;0
WireConnection;2;2;16;0
ASEEND*/
//CHKSM=3F959744E732611351EAEB260EA422B7DB8F5328