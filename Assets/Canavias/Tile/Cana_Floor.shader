// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cana_Floor"
{
	Properties
	{
		_BaseMap("BaseMap", 2D) = "white" {}
		_BaseColorIntensity("BaseColorIntensity", Float) = 1
		_EmissionIntensity("EmissionIntensity", Float) = 0
		_NormalMap("NormalMap", 2D) = "bump" {}
		_Roughness("Roughness", 2D) = "white" {}
		_Metal("Metal", Range( 0 , 1)) = 0
		_RoughnessControl("RoughnessControl", Range( -1 , 1)) = 0
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _BaseMap;
		uniform float4 _BaseMap_ST;
		uniform float4 _BaseColor;
		uniform float _BaseColorIntensity;
		uniform float _EmissionIntensity;
		uniform float _Metal;
		uniform sampler2D _Roughness;
		SamplerState sampler_Roughness;
		uniform float4 _Roughness_ST;
		uniform float _RoughnessControl;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float2 uv_BaseMap = i.uv_texcoord * _BaseMap_ST.xy + _BaseMap_ST.zw;
			float4 lerpResult18 = lerp( ( tex2D( _BaseMap, uv_BaseMap ) * _BaseColor ) , _BaseColor , _BaseColor.a);
			o.Albedo = ( lerpResult18 * _BaseColorIntensity ).rgb;
			o.Emission = ( lerpResult18 * _EmissionIntensity ).rgb;
			o.Metallic = _Metal;
			float2 uv_Roughness = i.uv_texcoord * _Roughness_ST.xy + _Roughness_ST.zw;
			o.Smoothness = saturate( ( ( 1.0 - tex2D( _Roughness, uv_Roughness ).r ) + _RoughnessControl ) );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
0;578;826.3333;399.6667;1973.155;485.4857;2.835394;True;True
Node;AmplifyShaderEditor.SamplerNode;8;-603.228,433.1729;Inherit;True;Property;_Roughness;Roughness;4;0;Create;True;0;0;False;0;False;-1;85be349ee0d92fd49ae735de7b228825;85be349ee0d92fd49ae735de7b228825;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-972.2278,-207.6331;Inherit;True;Property;_BaseMap;BaseMap;0;0;Create;True;0;0;False;0;False;-1;e77f9feb9e3c824498c348cd0505535c;e77f9feb9e3c824498c348cd0505535c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-890.1724,-13.22418;Inherit;False;Property;_BaseColor;BaseColor;7;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;9;-268.136,459.1202;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-340.2574,562.13;Inherit;False;Property;_RoughnessControl;RoughnessControl;6;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-653.7134,-157.5333;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-355.4073,-158.2469;Inherit;False;Property;_BaseColorIntensity;BaseColorIntensity;1;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-387.5208,97.93031;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-65.09436,448.1912;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;-518.9812,-101.0268;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-145.9677,-91.40442;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;7;-469.9244,229.995;Inherit;True;Property;_NormalMap;NormalMap;3;0;Create;True;0;0;False;0;False;-1;1cc6f73601e3ff04e99dccef5bbfe119;1cc6f73601e3ff04e99dccef5bbfe119;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-178.9856,32.87044;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-147.8975,177.6976;Inherit;False;Property;_Metal;Metal;5;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;15;50.69254,434.0516;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;271.0728,-15.21442;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Cana_Floor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;8;1
WireConnection;16;0;2;0
WireConnection;16;1;17;0
WireConnection;14;0;9;0
WireConnection;14;1;13;0
WireConnection;18;0;16;0
WireConnection;18;1;17;0
WireConnection;18;2;17;4
WireConnection;3;0;18;0
WireConnection;3;1;4;0
WireConnection;5;0;18;0
WireConnection;5;1;6;0
WireConnection;15;0;14;0
WireConnection;0;0;3;0
WireConnection;0;1;7;0
WireConnection;0;2;5;0
WireConnection;0;3;10;0
WireConnection;0;4;15;0
ASEEND*/
//CHKSM=A517795F2C103011F884FFB2021B9E4EBA3AC008