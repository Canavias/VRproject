// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Curtain"
{
	Properties
	{
		_SpecColor("Specular Color",Color)=(1,1,1,1)
		_Normal("Normal", 2D) = "white" {}
		_Rough("Rough", 2D) = "white" {}
		_RoughIntensity("RoughIntensity", Float) = 0
		[HDR]_BaseColor("BaseColor", Color) = (0,0,0,0)
		[HDR]_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		Stencil
		{
			Ref 1
			CompFront Always
			PassFront Replace
		}
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf BlinnPhong keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		SamplerState sampler_Normal;
		uniform float4 _Normal_ST;
		uniform float4 _BaseColor;
		uniform sampler2D _Rough;
		SamplerState sampler_Rough;
		uniform float4 _Rough_ST;
		uniform float _RoughIntensity;
		uniform float4 _EmissionColor;

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float4 tex2DNode2 = tex2D( _Normal, uv_Normal );
			float3 appendResult12 = (float3(tex2DNode2.r , tex2DNode2.b , tex2DNode2.g));
			o.Normal = appendResult12;
			float2 uv_Rough = i.uv_texcoord * _Rough_ST.xy + _Rough_ST.zw;
			float clampResult11 = clamp( ( tex2D( _Rough, uv_Rough ).r * _RoughIntensity ) , 0.0 , 1.0 );
			o.Albedo = ( _BaseColor * clampResult11 ).rgb;
			o.Emission = _EmissionColor.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
0;881.3334;1425.667;469.6667;140.7768;112.5878;1;True;False
Node;AmplifyShaderEditor.SamplerNode;3;-443.8671,-23.05607;Inherit;True;Property;_Rough;Rough;2;0;Create;True;0;0;False;0;False;-1;27cdfeadb5185384fb5bff2c03fddf30;27cdfeadb5185384fb5bff2c03fddf30;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-342.8494,170.0766;Inherit;False;Property;_RoughIntensity;RoughIntensity;3;0;Create;True;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-38.84938,78.07654;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;11;107.9964,67.46959;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-174.9039,300.0356;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;False;0;False;-1;8321d6b851b158c478544a06cc3d915a;8321d6b851b158c478544a06cc3d915a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-87.47234,-216.0622;Inherit;False;Property;_BaseColor;BaseColor;4;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0.380503,0.8342193,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;213.2611,-70.18082;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;126.936,295.4738;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;13;425.2825,233.3273;Inherit;False;Property;_EmissionColor;EmissionColor;5;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0.380503,0.8342193,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;704.7209,-70.6646;Float;False;True;-1;2;ASEMaterialInspector;0;0;BlinnPhong;Curtain;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;True;1;False;-1;255;False;-1;255;False;-1;7;False;-1;3;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;0;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;3;1
WireConnection;6;1;7;0
WireConnection;11;0;6;0
WireConnection;5;0;4;0
WireConnection;5;1;11;0
WireConnection;12;0;2;1
WireConnection;12;1;2;3
WireConnection;12;2;2;2
WireConnection;0;0;5;0
WireConnection;0;1;12;0
WireConnection;0;2;13;0
ASEEND*/
//CHKSM=BB24ED201DD40A5001074DBA5313CDAFB9862398