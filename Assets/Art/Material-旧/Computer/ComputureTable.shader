// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ComputureTable"
{
	Properties
	{
		_BaseTex("BaseTex", 2D) = "white" {}
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		_BaseColorIntensity("BaseColorIntensity", Float) = 1
		_NoiseCaustic02("NoiseCaustic02", 2D) = "white" {}
		_NoiseIntensity("NoiseIntensity", Float) = 0
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
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _BaseColorIntensity;
		uniform float4 _BaseColor;
		uniform sampler2D _BaseTex;
		SamplerState sampler_BaseTex;
		uniform float4 _BaseTex_ST;
		uniform sampler2D _NoiseCaustic02;
		SamplerState sampler_NoiseCaustic02;
		uniform float4 _NoiseCaustic02_ST;
		uniform float _NoiseIntensity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_BaseTex = i.uv_texcoord * _BaseTex_ST.xy + _BaseTex_ST.zw;
			float2 uv_NoiseCaustic02 = i.uv_texcoord * _NoiseCaustic02_ST.xy + _NoiseCaustic02_ST.zw;
			float4 tex2DNode7 = tex2D( _NoiseCaustic02, uv_NoiseCaustic02 );
			float2 appendResult8 = (float2(tex2DNode7.r , tex2DNode7.g));
			o.Emission = ( ( _BaseColorIntensity * _BaseColor ) + ( _BaseColor * tex2D( _BaseTex, ( uv_BaseTex + ( appendResult8 * _NoiseIntensity ) ) ).r ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
0;967.3334;1425.667;383.6667;1481.634;-8.129486;1;True;False
Node;AmplifyShaderEditor.SamplerNode;7;-1310.978,367.3854;Inherit;True;Property;_NoiseCaustic02;NoiseCaustic02;3;0;Create;True;0;0;False;0;False;-1;87aa55e4c3c29db4bbb4ad9a788d57c8;87aa55e4c3c29db4bbb4ad9a788d57c8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;8;-966.6802,342.5563;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-933.6443,474.7188;Inherit;False;Property;_NoiseIntensity;NoiseIntensity;4;0;Create;True;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-801.6443,344.0521;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-982.5282,106.6402;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-604.6616,234.9068;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-483.069,116.0551;Inherit;True;Property;_BaseTex;BaseTex;0;0;Create;True;0;0;False;0;False;-1;87196b381816671428e48d361087204d;87196b381816671428e48d361087204d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-387.2922,-113.7461;Inherit;False;Property;_BaseColor;BaseColor;1;0;Create;True;0;0;False;0;False;0,0,0,0;0.7711126,0.7943848,0.7987421,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-290.8396,-221.06;Inherit;False;Property;_BaseColorIntensity;BaseColorIntensity;2;0;Create;True;0;0;False;0;False;1;0.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-121.1578,-17.04158;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-35.50623,-159.7267;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;4;126.2061,-105.271;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;239.2668,-123.2666;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ComputureTable;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;True;1;False;-1;255;False;-1;255;False;-1;7;False;-1;3;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;7;1
WireConnection;8;1;7;2
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;12;0;11;0
WireConnection;12;1;10;0
WireConnection;1;1;12;0
WireConnection;3;0;2;0
WireConnection;3;1;1;1
WireConnection;6;0;5;0
WireConnection;6;1;2;0
WireConnection;4;0;6;0
WireConnection;4;1;3;0
WireConnection;0;2;4;0
ASEEND*/
//CHKSM=9ADC32472B65920F8321AE617D9E695650693BDF