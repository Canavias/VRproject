// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Plane"
{
	Properties
	{
		_PlaneColor("PlaneColor", 2D) = "white" {}
		[HDR]_EdgeColor("EdgeColor", Color) = (1,1,1,0)
		_Noise("Noise", 2D) = "white" {}
		[HDR]_FlowEdgeColor("FlowEdgeColor", Color) = (1,1,1,0)
		_Size("Size", Range( 0 , 10)) = 1
		_FlowEdgeDir("FlowEdgeDir", Vector) = (0,0,0,0)
		_FlowEdgeStrength("FlowEdgeStrength", Vector) = (0,0,0,0)
		_FlowEdgeSpeed("FlowEdgeSpeed", Float) = 0
		_FlowEdgePower("FlowEdgePower", Float) = 1
		_FlowEdgeScale("FlowEdgeScale", Float) = 1
		_DepthPower("DepthPower", Float) = 1
		[HDR]_DepthColor("DepthColor", Color) = (0,0,0,0)
		_DepthDistance("DepthDistance", Float) = 0
		_Alpha("Alpha", Float) = 0.1
		_VertexIntensity("VertexIntensity", Float) = 0
		_NoiseSpeed("NoiseSpeed", Float) = 0
		_NoiseMax("NoiseMax", Float) = 0
		_NoiseMin("NoiseMin", Float) = 0
		_Noise2("Noise2", 2D) = "white" {}
		_FlowPower("FlowPower", Float) = 0
		_FlowColor("FlowColor", Color) = (0,0,0,0)
		_FlowNoiseTilling("FlowNoiseTilling", Vector) = (0,0,0,0)
		_FlowNoiseDepth("FlowNoiseDepth", Float) = 2
		_FlowScale("FlowScale", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float4 screenPos;
			float2 uv2_texcoord2;
			float2 uv_texcoord;
		};

		uniform float _NoiseMin;
		uniform float _NoiseMax;
		uniform float _NoiseSpeed;
		uniform float _VertexIntensity;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthDistance;
		uniform float _DepthPower;
		uniform float4 _DepthColor;
		uniform float4 _FlowEdgeColor;
		uniform sampler2D _Noise;
		uniform float4 _Noise_ST;
		uniform float _Size;
		uniform float2 _FlowEdgeDir;
		uniform float2 _FlowEdgeStrength;
		uniform float _FlowEdgeSpeed;
		uniform float _FlowEdgePower;
		uniform float _FlowEdgeScale;
		uniform float4 _EdgeColor;
		uniform sampler2D _PlaneColor;
		SamplerState sampler_PlaneColor;
		uniform sampler2D _Noise2;
		SamplerState sampler_Noise2;
		uniform float2 _FlowNoiseTilling;
		uniform float _FlowNoiseDepth;
		uniform float _FlowPower;
		uniform float _FlowScale;
		uniform float4 _FlowColor;
		uniform float _Alpha;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 appendResult70 = (float3(ase_worldNormal.z , ase_worldNormal.y , ase_worldNormal.x));
			float mulTime52 = _Time.y * _NoiseSpeed;
			float simplePerlin2D59 = snoise( ( v.texcoord2.xy + mulTime52 ) );
			simplePerlin2D59 = simplePerlin2D59*0.5 + 0.5;
			float clampResult65 = clamp( simplePerlin2D59 , 0.0 , 1.0 );
			float smoothstepResult61 = smoothstep( _NoiseMin , _NoiseMax , (clampResult65*2.0 + -1.0));
			float3 VertexOffset75 = ( appendResult70 * smoothstepResult61 * _VertexIntensity );
			v.vertex.xyz += VertexOffset75;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth29 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth29 = abs( ( screenDepth29 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( ( _DepthDistance * 0.01 ) ) );
			float clampResult32 = clamp( ( 1.0 - distanceDepth29 ) , 0.0 , 1.0 );
			float Depth36 = pow( clampResult32 , _DepthPower );
			float4 temp_output_39_0 = ( Depth36 * _DepthColor );
			float2 uv2_Noise = i.uv2_texcoord2 * _Noise_ST.xy + _Noise_ST.zw;
			float2 temp_output_4_0_g1 = (( uv2_Noise / _Size )).xy;
			float2 temp_output_41_0_g1 = ( _FlowEdgeDir + 0.5 );
			float2 temp_output_17_0_g1 = _FlowEdgeStrength;
			float mulTime22_g1 = _Time.y * _FlowEdgeSpeed;
			float temp_output_27_0_g1 = frac( mulTime22_g1 );
			float2 temp_output_11_0_g1 = ( temp_output_4_0_g1 + ( temp_output_41_0_g1 * temp_output_17_0_g1 * temp_output_27_0_g1 ) );
			float2 temp_output_12_0_g1 = ( temp_output_4_0_g1 + ( temp_output_41_0_g1 * temp_output_17_0_g1 * frac( ( mulTime22_g1 + 0.5 ) ) ) );
			float3 lerpResult9_g1 = lerp( UnpackNormal( tex2D( _Noise, temp_output_11_0_g1 ) ) , UnpackNormal( tex2D( _Noise, temp_output_12_0_g1 ) ) , ( abs( ( temp_output_27_0_g1 - 0.5 ) ) / 0.5 ));
			float3 break16 = lerpResult9_g1;
			float clampResult23 = clamp( break16.x , 0.0 , 1.0 );
			float FlowMapX18 = ( pow( clampResult23 , _FlowEdgePower ) * _FlowEdgeScale );
			float4 tex2DNode1 = tex2D( _PlaneColor, i.uv_texcoord );
			float4 temp_output_3_0 = ( _EdgeColor * tex2DNode1.r );
			float2 appendResult46 = (float2(break16.y , break16.z));
			float2 FlowMapYZ45 = appendResult46;
			float4 FlowColor87 = ( ( pow( tex2D( _Noise2, ( ( i.uv2_texcoord2 * _FlowNoiseTilling ) + ( ( ( Depth36 * _FlowNoiseDepth ) * FlowMapYZ45 ) + FlowMapYZ45 ) ) ).r , _FlowPower ) * _FlowScale ) * _FlowColor );
			o.Emission = ( ( temp_output_39_0 + ( ( temp_output_39_0 + ( _FlowEdgeColor * FlowMapX18 ) ) * temp_output_3_0 ) + temp_output_3_0 ) + FlowColor87 ).rgb;
			float clampResult71 = clamp( ( tex2DNode1.r + _Alpha ) , 0.0 , 1.0 );
			o.Alpha = clampResult71;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv2_texcoord2;
				o.customPack1.xy = v.texcoord1;
				o.customPack1.zw = customInputData.uv_texcoord;
				o.customPack1.zw = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv2_texcoord2 = IN.customPack1.xy;
				surfIN.uv_texcoord = IN.customPack1.zw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.screenPos = IN.screenPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
311;890;1641;469;3828.494;-423.865;1.331778;True;True
Node;AmplifyShaderEditor.CommentaryNode;35;-3139.311,-720.9309;Inherit;False;1402.195;410.1033;;8;36;32;31;29;33;30;41;42;Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-3098.094,-441.4504;Inherit;False;Property;_DepthDistance;DepthDistance;14;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-2908.962,-423.3449;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;29;-2732.283,-462.5023;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;14;-1671.343,-1237.014;Inherit;False;1966.409;795.543;FlowMap;15;18;23;16;5;9;11;6;8;24;26;27;28;45;46;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;8;-1476.032,-1187.014;Inherit;True;Property;_Noise;Noise;2;0;Create;True;0;0;False;0;False;None;7e57ec7eaa0e7164096f3ab848f35b65;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1473.688,-997.2313;Inherit;False;1;8;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-1385.562,-574.1898;Inherit;False;Property;_FlowEdgeSpeed;FlowEdgeSpeed;9;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;11;-1418.562,-753.1899;Inherit;False;Property;_FlowEdgeStrength;FlowEdgeStrength;8;0;Create;True;0;0;False;0;False;0,0;2,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;9;-1406.243,-876.8434;Inherit;False;Property;_FlowEdgeDir;FlowEdgeDir;7;0;Create;True;0;0;False;0;False;0,0;-0.6,0.25;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;31;-2479.427,-450.689;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;5;-1083.595,-726.5729;Inherit;False;Flow;4;;1;acad10cc8145e1f4eb8042bebe2d9a42;2,50,1,51,1;5;5;SAMPLER2D;;False;2;FLOAT2;0,0;False;18;FLOAT2;0,0;False;17;FLOAT2;1,1;False;24;FLOAT;0.2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;32;-2334.076,-673.0568;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2264.898,-506.6024;Inherit;False;Property;_DepthPower;DepthPower;12;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;16;-804.0909,-733.2762;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PowerNode;41;-2103.898,-590.6024;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;46;-479.9475,-748.7073;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;88;-3381.104,358.0883;Inherit;False;1733.558;641.131;;18;92;87;82;81;85;86;84;83;78;94;100;102;103;104;105;106;107;108;FlowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-1916.899,-646.8706;Inherit;False;Depth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-3355.312,687.3241;Inherit;False;36;Depth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-3326.413,770.1272;Inherit;False;Property;_FlowNoiseDepth;FlowNoiseDepth;24;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-274.8903,-721.9819;Inherit;False;FlowMapYZ;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-3247.386,872.9862;Inherit;False;45;FlowMapYZ;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;74;-4027.403,-279.7413;Inherit;False;2498.958;589.6223;;15;69;61;63;66;62;65;59;60;52;58;54;70;67;68;75;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-3177.254,680.8978;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-3977.403,110.4208;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;17;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;103;-3332.714,550.3737;Inherit;False;Property;_FlowNoiseTilling;FlowNoiseTilling;23;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;24;-502.0318,-911.7161;Inherit;False;Property;_FlowEdgePower;FlowEdgePower;10;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;23;-520.6606,-1033.641;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;92;-3354.124,415.253;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-3055.433,675.3146;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;52;-3800.765,113.8177;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-3885.626,-15.46019;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;26;-276.0318,-1032.716;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-3099.112,406.9624;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-262.0318,-905.7161;Inherit;False;Property;_FlowEdgeScale;FlowEdgeScale;11;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-2892.765,703.6234;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-115.0318,-1023.716;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;100;-2941.446,435.7094;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-3589.593,-12.6162;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-2666.752,600.492;Inherit;False;Property;_FlowPower;FlowPower;21;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;25.70057,-1044.393;Inherit;False;FlowMapX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;59;-3452.212,-19.24901;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;78;-2815.653,408.0883;Inherit;True;Property;_Noise2;Noise2;20;0;Create;True;0;0;False;0;False;-1;87aa55e4c3c29db4bbb4ad9a788d57c8;87aa55e4c3c29db4bbb4ad9a788d57c8;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;19;-1077.987,206.9488;Inherit;False;Property;_FlowEdgeColor;FlowEdgeColor;3;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;84;-2517.987,453.9127;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;65;-3188.22,-15.64427;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-1061.427,385.9211;Inherit;False;18;FlowMapX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-2485.269,623.8572;Inherit;False;Property;_FlowScale;FlowScale;25;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-998.6669,-176.4896;Inherit;False;36;Depth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;-1022.492,-51.98547;Inherit;False;Property;_DepthColor;DepthColor;13;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1434.716,719.9478;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-2340.269,479.8572;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1168.418,711.5577;Inherit;True;Property;_PlaneColor;PlaneColor;0;0;Create;True;0;0;False;0;False;-1;70b339c716753d84e89e77b51cc220bd;70b339c716753d84e89e77b51cc220bd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;63;-2931.525,214.5747;Inherit;False;Property;_NoiseMax;NoiseMax;18;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;67;-2751.033,-229.5057;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-828.1088,349.0779;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2934.111,138.2947;Inherit;False;Property;_NoiseMin;NoiseMin;19;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;81;-2718.323,812.216;Inherit;False;Property;_FlowColor;FlowColor;22;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;66;-2976.726,-26.81374;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-699.1476,-31.01085;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2;-1143.234,535.6306;Inherit;False;Property;_EdgeColor;EdgeColor;1;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;0.1556604,0.8304673,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;70;-2499.971,-208.1686;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-771.353,553.7302;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-2122.027,518.0552;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-548.478,177.0592;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;61;-2729.918,-31.18898;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-2446.569,-27.47536;Inherit;False;Property;_VertexIntensity;VertexIntensity;16;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-419.0245,301.4085;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-706.4335,915.8798;Inherit;False;Property;_Alpha;Alpha;15;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2261.82,-229.7413;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;-1886.945,527.5967;Inherit;False;FlowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-80.15727,332.6587;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-127.7207,461.6208;Inherit;False;87;FlowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-1984.886,-192.8671;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-536.1588,822.3681;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-1536.711,36.05411;Inherit;False;-1;;1;0;OBJECT;;False;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;101.9722,344.4564;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;-225.3596,974.0842;Inherit;False;75;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;71;-225.0193,827.1573;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;321.2918,403.8082;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Plane;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;33;0;30;0
WireConnection;29;0;33;0
WireConnection;31;0;29;0
WireConnection;5;5;8;0
WireConnection;5;2;6;0
WireConnection;5;18;9;0
WireConnection;5;17;11;0
WireConnection;5;24;12;0
WireConnection;32;0;31;0
WireConnection;16;0;5;0
WireConnection;41;0;32;0
WireConnection;41;1;42;0
WireConnection;46;0;16;1
WireConnection;46;1;16;2
WireConnection;36;0;41;0
WireConnection;45;0;46;0
WireConnection;107;0;104;0
WireConnection;107;1;108;0
WireConnection;23;0;16;0
WireConnection;105;0;107;0
WireConnection;105;1;102;0
WireConnection;52;0;54;0
WireConnection;26;0;23;0
WireConnection;26;1;24;0
WireConnection;94;0;92;0
WireConnection;94;1;103;0
WireConnection;106;0;105;0
WireConnection;106;1;102;0
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;100;0;94;0
WireConnection;100;1;106;0
WireConnection;60;0;58;0
WireConnection;60;1;52;0
WireConnection;18;0;28;0
WireConnection;59;0;60;0
WireConnection;78;1;100;0
WireConnection;84;0;78;1
WireConnection;84;1;83;0
WireConnection;65;0;59;0
WireConnection;85;0;84;0
WireConnection;85;1;86;0
WireConnection;1;1;4;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;66;0;65;0
WireConnection;39;0;37;0
WireConnection;39;1;38;0
WireConnection;70;0;67;3
WireConnection;70;1;67;2
WireConnection;70;2;67;1
WireConnection;3;0;2;0
WireConnection;3;1;1;1
WireConnection;82;0;85;0
WireConnection;82;1;81;0
WireConnection;40;0;39;0
WireConnection;40;1;21;0
WireConnection;61;0;66;0
WireConnection;61;1;62;0
WireConnection;61;2;63;0
WireConnection;13;0;40;0
WireConnection;13;1;3;0
WireConnection;68;0;70;0
WireConnection;68;1;61;0
WireConnection;68;2;69;0
WireConnection;87;0;82;0
WireConnection;22;0;39;0
WireConnection;22;1;13;0
WireConnection;22;2;3;0
WireConnection;75;0;68;0
WireConnection;43;0;1;1
WireConnection;43;1;44;0
WireConnection;90;0;22;0
WireConnection;90;1;91;0
WireConnection;71;0;43;0
WireConnection;0;2;90;0
WireConnection;0;9;71;0
WireConnection;0;11;76;0
ASEEND*/
//CHKSM=460DE92A4F84BF8E92C9E6C583FB8EBACBD42B8B