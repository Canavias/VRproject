// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Transmation"
{
	Properties
	{
		_FlowNoise("FlowNoise", 2D) = "white" {}
		[HDR]_NoiseColor("NoiseColor", Color) = (0,0,0,0)
		_NoiseTilling("NoiseTilling", Vector) = (0,0,0,0)
		_NoiseTimeScale("NoiseTimeScale", Float) = 1
		_DistanceMin("DistanceMin", Float) = 0
		_DistanceMax("DistanceMax", Float) = 1
		_NoisePower("NoisePower", Float) = 1
		_FlowMap("FlowMap", 2D) = "white" {}
		_FlowMapIntensity("FlowMapIntensity", Float) = 0
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		_FlowBoise2("FlowBoise2", 2D) = "white" {}
		_TimeScale2("TimeScale2", Float) = 0
		_FlowNoise2("FlowNoise2", Vector) = (0,0,0,0)
		_FlowNoiseBase("FlowNoiseBase", Range( 0 , 1)) = 0
		_FlowNoisePower("FlowNoisePower", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Front
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _DistanceMin;
		uniform float _DistanceMax;
		uniform sampler2D _FlowNoise;
		SamplerState sampler_FlowNoise;
		uniform float4 _NoiseTilling;
		uniform float _NoiseTimeScale;
		uniform sampler2D _FlowMap;
		SamplerState sampler_FlowMap;
		uniform float4 _FlowMap_ST;
		uniform float _FlowMapIntensity;
		uniform float _NoisePower;
		uniform float4 _NoiseColor;
		uniform float _TimeScale2;
		uniform sampler2D _FlowBoise2;
		SamplerState sampler_FlowBoise2;
		uniform float4 _FlowBoise2_ST;
		uniform float2 _FlowNoise2;
		uniform float _FlowNoiseBase;
		uniform float _FlowNoisePower;
		uniform float4 _BaseColor;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float temp_output_40_0 = sin( _Time.y );
			float clampResult20 = clamp( distance( i.uv_texcoord.y , (temp_output_40_0*0.2 + 0.5) ) , 0.0 , 1.0 );
			float smoothstepResult22 = smoothstep( _DistanceMin , _DistanceMax , ( 1.0 - clampResult20 ));
			float2 appendResult8 = (float2(_NoiseTilling.x , _NoiseTilling.y));
			float2 appendResult10 = (float2(_NoiseTilling.z , _NoiseTilling.w));
			float mulTime12 = _Time.y * _NoiseTimeScale;
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float4 tex2DNode32 = tex2D( _FlowMap, uv_FlowMap );
			float2 appendResult33 = (float2(tex2DNode32.g , tex2DNode32.r));
			float mulTime68 = _Time.y * _TimeScale2;
			float clampResult61 = clamp( ( frac( mulTime68 ) * 6.0 ) , 0.0 , 6.0 );
			float V42 = i.uv_texcoord.x;
			float clampResult52 = clamp( ( ( temp_output_40_0 * 0.5 ) + V42 ) , 0.0 , 1.5 );
			float4 appendResult43 = (float4(( _NoiseColor.r * clampResult61 ) , ( _NoiseColor.g * clampResult52 ) , _NoiseColor.b , _NoiseColor.a));
			float2 uv_FlowBoise2 = i.uv_texcoord * _FlowBoise2_ST.xy + _FlowBoise2_ST.zw;
			o.Emission = ( ( ( ( smoothstepResult22 * pow( tex2D( _FlowNoise, ( ( i.uv_texcoord * appendResult8 ) + ( appendResult10 * mulTime12 ) + ( appendResult33 * ( _FlowMapIntensity * temp_output_40_0 ) ) ) ).r , _NoisePower ) ) * appendResult43 ) * pow( ( tex2D( _FlowBoise2, ( uv_FlowBoise2 + ( _FlowNoise2 * mulTime68 ) ) ).r + _FlowNoiseBase ) , _FlowNoisePower ) ) + _BaseColor ).xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
0;673.3334;1333;677.6667;1535.345;639.4642;2.070314;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;39;-1999.975,349.5565;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-1853.126,722.6491;Inherit;False;Property;_TimeScale2;TimeScale2;11;0;Create;True;0;0;False;0;False;0;1.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;7;-1984.42,-476.5655;Inherit;False;Property;_NoiseTilling;NoiseTilling;2;0;Create;True;0;0;False;0;False;0,0,0,0;30,0.8,-0.1,0.5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-1276.341,-946.617;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-2070.226,-227.9054;Inherit;False;Property;_NoiseTimeScale;NoiseTimeScale;3;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;40;-1824.822,341.5008;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2003.21,176.1737;Inherit;False;Property;_FlowMapIntensity;FlowMapIntensity;8;0;Create;True;0;0;False;0;False;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;32;-2022.037,-50.04687;Inherit;True;Property;_FlowMap;FlowMap;7;0;Create;True;0;0;False;0;False;-1;9189a673eb50ec94786a47a286287a49;9189a673eb50ec94786a47a286287a49;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;12;-1848.226,-229.9054;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;68;-1614.703,715.7743;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;53;-1233.731,-776.5135;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-1687.201,-67.55255;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-2014.612,-666.3778;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;10;-1773.42,-331.5655;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-488.0681,-618.7137;Inherit;False;V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-1806.42,-460.5655;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1575.309,142.2902;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;18;-997.2699,-829.0323;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1653.42,-578.5656;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-1198.038,289.5245;Inherit;False;42;V;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1453.171,-198.1131;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1528.187,-396.0919;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;71;-1459.526,630.9679;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;63;-1158.713,623.8916;Inherit;False;Property;_FlowNoise2;FlowNoise2;12;0;Create;True;0;0;False;0;False;0,0;-0.1,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-1471.414,290.267;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-874.1246,427.4456;Inherit;False;0;62;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;20;-831.7623,-824.6953;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-777.2344,603.9739;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1002.503,120.9236;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-1297.818,-565.0959;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-1317.128,503.5826;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;6;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-709.5134,-611.1006;Inherit;False;Property;_DistanceMax;DistanceMax;5;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;61;-1142.97,21.88723;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-580.0211,455.5687;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-901.0139,-303.5525;Inherit;False;Property;_NoisePower;NoisePower;6;0;Create;True;0;0;False;0;False;1;3.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;-678.3842,-819.7933;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;52;-812.2074,102.9112;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-713.5134,-716.1006;Inherit;False;Property;_DistanceMin;DistanceMin;4;0;Create;True;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1054.773,-500.9344;Inherit;True;Property;_FlowNoise;FlowNoise;0;0;Create;True;0;0;False;0;False;-1;7e57ec7eaa0e7164096f3ab848f35b65;1dbe0e16737522f4f8a8ab5a145e88b3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-1193.979,-190.3113;Inherit;False;Property;_NoiseColor;NoiseColor;1;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;1.201258,5.340313,2.996078,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;22;-505.0196,-802.5654;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-451.4974,675.0861;Inherit;False;Property;_FlowNoiseBase;FlowNoiseBase;13;0;Create;True;0;0;False;0;False;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-886.5124,-185.4962;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-639.6556,-7.428776;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;62;-428.453,422.3856;Inherit;True;Property;_FlowBoise2;FlowBoise2;10;0;Create;True;0;0;False;0;False;-1;87aa55e4c3c29db4bbb4ad9a788d57c8;a8f9f17da57160445be1b7179937d401;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;30;-675.8156,-411.091;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-130.4838,602.2548;Inherit;False;Property;_FlowNoisePower;FlowNoisePower;14;0;Create;True;0;0;False;0;False;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-119.8846,437.6547;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-407.5798,-494.8779;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;43;-412.3323,-160.545;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PowerNode;75;53.43753,321.6332;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-76.99898,-487.699;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;201.4025,-443.1868;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;57;416.008,-328.9673;Inherit;False;Property;_BaseColor;BaseColor;9;0;Create;True;0;0;False;0;False;0,0,0,0;0.2575979,0.4339622,0.1371483,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;56;689.6955,-418.0818;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;873.7128,-261.1486;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Transmation;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Front;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;40;0;39;0
WireConnection;12;0;13;0
WireConnection;68;0;67;0
WireConnection;53;0;40;0
WireConnection;33;0;32;2
WireConnection;33;1;32;1
WireConnection;10;0;7;3
WireConnection;10;1;7;4
WireConnection;42;0;16;1
WireConnection;8;0;7;1
WireConnection;8;1;7;2
WireConnection;38;0;35;0
WireConnection;38;1;40;0
WireConnection;18;0;16;2
WireConnection;18;1;53;0
WireConnection;9;0;6;0
WireConnection;9;1;8;0
WireConnection;34;0;33;0
WireConnection;34;1;38;0
WireConnection;14;0;10;0
WireConnection;14;1;12;0
WireConnection;71;0;68;0
WireConnection;58;0;40;0
WireConnection;20;0;18;0
WireConnection;66;0;63;0
WireConnection;66;1;68;0
WireConnection;51;0;58;0
WireConnection;51;1;44;0
WireConnection;11;0;9;0
WireConnection;11;1;14;0
WireConnection;11;2;34;0
WireConnection;72;0;71;0
WireConnection;61;0;72;0
WireConnection;65;0;64;0
WireConnection;65;1;66;0
WireConnection;19;0;20;0
WireConnection;52;0;51;0
WireConnection;3;1;11;0
WireConnection;22;0;19;0
WireConnection;22;1;23;0
WireConnection;22;2;24;0
WireConnection;60;0;4;1
WireConnection;60;1;61;0
WireConnection;46;0;4;2
WireConnection;46;1;52;0
WireConnection;62;1;65;0
WireConnection;30;0;3;1
WireConnection;30;1;31;0
WireConnection;73;0;62;1
WireConnection;73;1;74;0
WireConnection;15;0;22;0
WireConnection;15;1;30;0
WireConnection;43;0;60;0
WireConnection;43;1;46;0
WireConnection;43;2;4;3
WireConnection;43;3;4;4
WireConnection;75;0;73;0
WireConnection;75;1;76;0
WireConnection;41;0;15;0
WireConnection;41;1;43;0
WireConnection;69;0;41;0
WireConnection;69;1;75;0
WireConnection;56;0;69;0
WireConnection;56;1;57;0
WireConnection;2;2;56;0
ASEEND*/
//CHKSM=D33004C9C58D1508865FE6DC04A52C2EF4D5DC10