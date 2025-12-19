// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New/MCShader"
{
	Properties
	{
		_BaseColor("BaseColor", 2D) = "white" {}
		_BaseColorIntensity("BaseColorIntensity", Float) = 1
		_EmissIntensity("EmissIntensity", Float) = 1
		_Metailic("Metailic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Roughness("Roughness", 2D) = "white" {}
		_BaseColorRGB("BaseColorRGB", Color) = (1,1,1,0)
		[HDR]_EmissionColor("EmissionColor", Color) = (1,1,1,0)
		_Noise("Noise", 2D) = "white" {}
		_NoiseTilling("NoiseTilling", Vector) = (0,0,0,0)
		_NoiseRange("NoiseRange", Range( -1 , 1)) = 1
		_Noise2Range("Noise2Range", Range( -1 , 1)) = 1
		_NoiseOffset("NoiseOffset", Vector) = (0,0,1,0)
		_Noise2Intensity("Noise2Intensity", Float) = 0.1
		_Noise2Position("Noise2Position", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float3 _NoiseOffset;
		uniform sampler2D _Noise;
		SamplerState sampler_Noise;
		uniform float2 _NoiseTilling;
		uniform float _NoiseRange;
		uniform float _Noise2Range;
		uniform float3 _Noise2Position;
		uniform float _Noise2Intensity;
		uniform sampler2D _BaseColor;
		uniform float _BaseColorIntensity;
		uniform float4 _BaseColorRGB;
		uniform float _EmissIntensity;
		uniform float4 _EmissionColor;
		uniform float _Metailic;
		uniform float _Smoothness;
		uniform sampler2D _Roughness;
		SamplerState sampler_Roughness;
		uniform float4 _Roughness_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 tex2DNode30 = tex2Dlod( _Noise, float4( ( v.texcoord1.xy * _NoiseTilling ), 0, 0.0) );
			float clampResult35 = clamp( ( tex2DNode30.r - _NoiseRange ) , 0.0 , 1.0 );
			float clampResult54 = clamp( ( tex2DNode30.r - _Noise2Range ) , 0.0 , 1.0 );
			float3 objToWorld56 = mul( unity_ObjectToWorld, float4( _Noise2Position, 1 ) ).xyz;
			float3 normalizeResult61 = normalize( ( objToWorld56 - ase_vertex3Pos ) );
			float3 VertexAnim50 = ( ase_vertex3Pos + ( _NoiseOffset * clampResult35 ) + ( clampResult54 * ( normalizeResult61 * _Noise2Intensity ) ) );
			v.vertex.xyz = VertexAnim50;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 tex2DNode1 = tex2D( _BaseColor, i.uv_texcoord );
			float4 BaseColor5 = ( tex2DNode1 * _BaseColorIntensity );
			o.Albedo = ( BaseColor5 * _BaseColorRGB ).rgb;
			float4 EmissionColor8 = ( _EmissIntensity * tex2DNode1 );
			o.Emission = ( EmissionColor8 * _EmissionColor ).rgb;
			o.Metallic = _Metailic;
			float2 uv_Roughness = i.uv_texcoord * _Roughness_ST.xy + _Roughness_ST.zw;
			float clampResult17 = clamp( ( _Smoothness + ( 1.0 - tex2D( _Roughness, uv_Roughness ).r ) ) , 0.0 , 1.0 );
			o.Smoothness = clampResult17;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
0;461.3333;475.6667;516.3334;1902.924;-1225.187;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;51;-2807.975,583.8516;Inherit;False;2024.148;1168.995;Comment;23;60;61;57;58;56;54;55;33;35;53;34;50;38;37;28;36;30;31;32;29;62;63;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;32;-2687.338,1068.467;Inherit;False;Property;_NoiseTilling;NoiseTilling;9;0;Create;True;0;0;False;0;False;0,0;2,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector3Node;65;-2472.049,1452.282;Inherit;False;Property;_Noise2Position;Noise2Position;14;0;Create;True;0;0;False;0;False;0,0,0;0.5,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-2757.975,943.9535;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;58;-2191.863,1591.526;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-2511.577,969.764;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TransformPositionNode;56;-2202.74,1442.708;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;57;-1929.803,1526.738;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;30;-2359.698,925.2267;Inherit;True;Property;_Noise;Noise;8;0;Create;True;0;0;False;0;False;-1;None;87aa55e4c3c29db4bbb4ad9a788d57c8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-2343.599,1347.48;Inherit;False;Property;_Noise2Range;Noise2Range;11;0;Create;True;0;0;False;0;False;1;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;9;-1266.747,-1046.749;Inherit;False;1030.894;581.1362;;9;2;4;3;5;1;6;7;8;18;Base;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-2348.66,1129.194;Inherit;False;Property;_NoiseRange;NoiseRange;10;0;Create;True;0;0;False;0;False;1;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;55;-1989.39,1300.153;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1216.747,-774.3876;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;61;-1760.437,1500.05;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-1739.389,1589.377;Inherit;False;Property;_Noise2Intensity;Noise2Intensity;13;0;Create;True;0;0;False;0;False;0.1;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;-1993.915,944.8463;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;35;-1812.736,988.3012;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-1560.824,1502.272;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-998.3795,-791.0259;Inherit;True;Property;_BaseColor;BaseColor;0;0;Create;True;0;0;False;0;False;-1;None;a305e49aff4b51c498393d7cc5e59234;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;54;-1811.411,1307.341;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-909.5917,-580.7731;Inherit;False;Property;_BaseColorIntensity;BaseColorIntensity;1;0;Create;True;0;0;False;0;False;1;2.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-872.0999,-996.7491;Inherit;False;Property;_EmissIntensity;EmissIntensity;2;0;Create;True;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;36;-1621.128,820.5187;Inherit;False;Property;_NoiseOffset;NoiseOffset;12;0;Create;True;0;0;False;0;False;0,0,1;0,0,0.2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1421.087,978.0898;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-634.8956,-925.5475;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-658.2584,-701.4396;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1447.753,1317.502;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;28;-1610.465,633.8516;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-1462.179,227.9701;Inherit;True;Property;_Roughness;Roughness;5;0;Create;True;0;0;False;0;False;-1;ca178fefc61360443b6d38f9ac6a4e34;ca178fefc61360443b6d38f9ac6a4e34;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-475.2529,-921.6263;Inherit;False;EmissionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1302.032,86.02018;Inherit;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;False;0;False;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;15;-1155.085,241.5564;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-514.6087,-700.5188;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-1232.199,751.1546;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-984.3588,146.3971;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;-583.8499,-139.316;Inherit;False;8;EmissionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-1012.026,773.268;Inherit;False;VertexAnim;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;27;-615.8698,-81.37196;Inherit;False;Property;_EmissionColor;EmissionColor;7;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;25;-507.4267,-360.9621;Inherit;False;Property;_BaseColorRGB;BaseColorRGB;6;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;10;-458.0912,-444.6634;Inherit;False;5;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-528.2839,-590.269;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;-359.483,273.1557;Inherit;False;50;VertexAnim;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-989.0355,55.65349;Inherit;False;Property;_Metailic;Metailic;3;0;Create;True;0;0;False;0;False;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-257.1351,-389.4302;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;17;-851.2412,132.7971;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-356.3076,-98.65501;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;New/MCShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;0;29;0
WireConnection;31;1;32;0
WireConnection;56;0;65;0
WireConnection;57;0;56;0
WireConnection;57;1;58;0
WireConnection;30;1;31;0
WireConnection;55;0;30;1
WireConnection;55;1;53;0
WireConnection;61;0;57;0
WireConnection;33;0;30;1
WireConnection;33;1;34;0
WireConnection;35;0;33;0
WireConnection;62;0;61;0
WireConnection;62;1;63;0
WireConnection;1;1;2;0
WireConnection;54;0;55;0
WireConnection;37;0;36;0
WireConnection;37;1;35;0
WireConnection;6;0;7;0
WireConnection;6;1;1;0
WireConnection;3;0;1;0
WireConnection;3;1;4;0
WireConnection;60;0;54;0
WireConnection;60;1;62;0
WireConnection;8;0;6;0
WireConnection;15;0;14;1
WireConnection;5;0;3;0
WireConnection;38;0;28;0
WireConnection;38;1;37;0
WireConnection;38;2;60;0
WireConnection;16;0;13;0
WireConnection;16;1;15;0
WireConnection;50;0;38;0
WireConnection;18;0;1;4
WireConnection;23;0;10;0
WireConnection;23;1;25;0
WireConnection;17;0;16;0
WireConnection;26;0;11;0
WireConnection;26;1;27;0
WireConnection;0;0;23;0
WireConnection;0;2;26;0
WireConnection;0;3;12;0
WireConnection;0;4;17;0
WireConnection;0;11;52;0
ASEEND*/
//CHKSM=8B3B64DCAEC1CBFB87F43592458C0A916ADDEF97