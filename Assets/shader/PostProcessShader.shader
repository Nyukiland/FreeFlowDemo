// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PostProcessShader"
{
	Properties
	{
		_OutlineSize("OutlineSize", Float) = 1
		_waveControl("waveControl", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Cull Off
		ZWrite Off
		ZTest Always
		
		Pass
		{
			CGPROGRAM

			

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_SCREEN_POSITION_NORMALIZED

		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _waveControl;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _OutlineSize;


			
			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v  )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				

				return o;
			}

			float4 Frag (ASEVaryingsDefault i  ) : SV_Target
			{
				float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				float2 uv_MainTex = i.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 color65 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 temp_cast_0 = (abs( _SinTime.w )).xxxx;
				float4 color281 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
				float4 ifLocalVar264 = 0;
				if( _waveControl > 0.0 )
				ifLocalVar264 = temp_cast_0;
				else if( _waveControl == 0.0 )
				ifLocalVar264 = color281;
				float2 appendResult133 = (float2(ase_ppsScreenPosFragNorm.x , ase_ppsScreenPosFragNorm.y));
				float eyeDepth132 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( appendResult133, 0.0 , 0.0 ).xy ));
				float2 appendResult77 = (float2(ase_ppsScreenPosFragNorm.x , ase_ppsScreenPosFragNorm.y));
				float2 appendResult102 = (float2(_MainTex_TexelSize.x , _MainTex_TexelSize.y));
				float2 appendResult260 = (float2(( _OutlineSize * -1.0 ) , _OutlineSize));
				float eyeDepth79 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( ( appendResult77 + ( appendResult102 * appendResult260 ) ), 0.0 , 0.0 ).xy ));
				float2 appendResult108 = (float2(ase_ppsScreenPosFragNorm.x , ase_ppsScreenPosFragNorm.y));
				float2 appendResult109 = (float2(_MainTex_TexelSize.x , _MainTex_TexelSize.y));
				float2 appendResult254 = (float2(_OutlineSize , ( _OutlineSize * -1.0 )));
				float eyeDepth107 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( ( appendResult108 + ( appendResult109 * appendResult254 ) ), 0.0 , 0.0 ).xy ));
				float2 appendResult116 = (float2(ase_ppsScreenPosFragNorm.x , ase_ppsScreenPosFragNorm.y));
				float2 appendResult117 = (float2(_MainTex_TexelSize.x , _MainTex_TexelSize.y));
				float temp_output_256_0 = ( _OutlineSize * -1.0 );
				float2 appendResult257 = (float2(temp_output_256_0 , temp_output_256_0));
				float eyeDepth115 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( ( appendResult116 + ( appendResult117 * appendResult257 ) ), 0.0 , 0.0 ).xy ));
				float2 appendResult124 = (float2(ase_ppsScreenPosFragNorm.x , ase_ppsScreenPosFragNorm.y));
				float2 appendResult125 = (float2(_MainTex_TexelSize.x , _MainTex_TexelSize.y));
				float2 appendResult258 = (float2(_OutlineSize , _OutlineSize));
				float eyeDepth123 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( ( appendResult124 + ( appendResult125 * appendResult258 ) ), 0.0 , 0.0 ).xy ));
				float4 lerpResult280 = lerp( float4( 0,0,0,0 ) , ifLocalVar264 , saturate( floor( ( ( eyeDepth132 * -4.0 ) + ( eyeDepth79 + eyeDepth107 + eyeDepth115 + eyeDepth123 ) ) ) ));
				float4 lerpResult57 = lerp( tex2D( _MainTex, uv_MainTex ) , color65 , lerpResult280);
				

				float4 color = lerpResult57;
				
				return color;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.CommentaryNode;284;-1032.98,1850.275;Inherit;False;717.236;637.7242;;6;288;275;274;281;262;264;Effet Clignotement;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;283;-1128.706,1496.235;Inherit;False;624.7382;316.7618;;4;287;139;138;137;Difference;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;282;-516.3281,1208.741;Inherit;False;620.1654;277;;2;59;58;Base Image;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;252;-3766.889,3279.03;Inherit;False;260;163;;1;251;Size Control;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;149;-3176.57,1682.383;Inherit;False;1971.147;2635.145;;29;117;116;115;114;113;112;111;122;121;125;119;120;123;124;104;109;108;107;106;105;103;127;148;253;254;256;257;258;273;allSide;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;148;-3088.22,1820.105;Inherit;False;1523.487;654.4675;the image depth but slightly to the side;10;67;78;79;77;66;102;75;259;260;286;side;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;147;-2764.252,1029.577;Inherit;False;1419.365;584.2654;;5;129;132;133;136;285;Base depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1205.362,98.64053;Inherit;False;1688.454;654.8;;12;20;21;22;11;12;13;15;16;14;17;18;19;BLUR;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;5;-802.8,-340.7;Inherit;False;611.6;301;To get the camera view;2;3;2;Camera;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCGrayscale;4;-157.692,-208.2332;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;415.308,-278.2332;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-502.8,-280.7;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;2;-752.8,-290.7;Inherit;True;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1;161.2,-115.7;Inherit;False;Property;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0.4245283,0.4101104,0.4101104,0.454902;0.4245283,0.4101104,0.4101104,0.454902;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;20;111.1933,254.8815;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;21;305.092,299.7315;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;18;-346.3624,445.6406;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;81.49203,375.1314;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;19;-550.3625,174.6405;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-342.3624,248.6404;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;14;-577.3626,269.6404;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-585.3626,483.6405;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;11;-1151.329,148.6405;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;12;-1154.329,331.6404;Inherit;False;0;0;_MainTex_TexelSize;Shader;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-865.33,254.6404;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-844.3625,480.6405;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;127;-1352.478,1965.289;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;102;-2756.221,2090.57;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-2503.099,2101.092;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;103;-2793.42,2765.063;Inherit;False;0;0;_MainTex_TexelSize;Shader;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-2394.407,2805.338;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-2125.408,2748.338;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;108;-2454.407,2605.337;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;104;-2790.42,2582.062;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;124;-2487.082,3788.342;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;120;-2823.095,3765.069;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;119;-2826.095,3948.069;Inherit;False;0;0;_MainTex_TexelSize;Shader;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;125;-2591.968,3967.333;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;-2427.083,3988.342;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;122;-2158.084,3931.342;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;111;-2826.648,3352.881;Inherit;False;0;0;_MainTex_TexelSize;Shader;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;112;-2823.648,3169.881;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-2427.636,3393.155;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;114;-2158.638,3336.155;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;116;-2487.636,3193.155;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;117;-2592.522,3372.146;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-1522.888,1295.629;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;115;-1957.638,3336.155;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;107;-1924.41,2748.338;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;79;-1806.734,2036.378;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;67;-2696.747,1861.105;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;77;-2450.734,1897.378;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenDepthNode;132;-1845.241,1245.851;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;123;-1918.084,3893.342;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;109;-2558.293,2784.329;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;-3066.425,3569.714;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;257;-2829.425,3584.714;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;258;-2878.425,4149.713;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;253;-3047.818,3067.43;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;254;-2797.425,3011.714;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;260;-2814.151,2335.463;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;259;-3064.451,2314.464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;273;-3105.246,3030.102;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;251;-3704.889,3333.03;Inherit;False;Property;_OutlineSize;OutlineSize;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;137;-1078.706,1546.235;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;138;-932.0956,1548.609;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;139;-720.9682,1570.997;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;264;-537.7443,1981.792;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;262;-982.9802,1900.275;Inherit;False;Property;_waveControl;waveControl;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;281;-939.0692,1976.682;Inherit;False;Constant;_Color2;Color 2;3;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;274;-900.1484,2158.999;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;275;-735.1464,2219.999;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode;285;-2237.661,1380.158;Inherit;False;388;187;Base Depth;;1,1,1,1;By giving the position of the pixel (screen position)$The system can calculate the depth and return me a value (screen depth)$$I then multiply it by -4, minus because I will use it to make the difference with other shifted images;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;129;-2617.252,1205.577;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;133;-2273.24,1240.851;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StickyNoteNode;286;-2297.661,2229.158;Inherit;False;388;187;Shifted Depth;;1,1,1,1;Using TexelSize I can shift my image by a certain amount (controlled by my multiply)$$I do this 4 time with each corner(top right, top left, down right, down left) creating the outline;0;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;66;-2990.347,2071.305;Inherit;False;0;0;_MainTex_TexelSize;Shader;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-2007.735,2036.378;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StickyNoteNode;287;-1058.791,1662.012;Inherit;False;518;116;Shifted Depth;;1,1,1,1;By adding my normal depth (that has been set negative) and all the shifted depth I get the Outline.$$I then floor and saturate to make sure i get only black and white;0;0
Node;AmplifyShaderEditor.StickyNoteNode;288;-927.7764,2332.016;Inherit;False;518;116;Used for an effect;;1,1,1,1;I just play with the outline i order to make it appear and disapear;0;0
Node;AmplifyShaderEditor.LerpOp;57;294.9123,1577.187;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;637.6628,1611.4;Float;False;True;-1;2;ASEMaterialInspector;0;8;PostProcessShader;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;7;False;;False;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.ColorNode;65;-130.6541,1519.878;Inherit;False;Constant;_Color1;Color 1;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;280;-24.39998,1752.869;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;59;-196.3286,1256.741;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;58;-452.3286,1256.741;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;4;0;3;0
WireConnection;10;0;3;0
WireConnection;10;1;1;0
WireConnection;3;0;2;0
WireConnection;20;0;17;0
WireConnection;20;1;18;0
WireConnection;21;0;20;0
WireConnection;21;1;22;0
WireConnection;18;0;19;0
WireConnection;18;1;16;0
WireConnection;17;0;19;0
WireConnection;17;1;14;0
WireConnection;14;0;13;0
WireConnection;14;1;11;2
WireConnection;16;0;15;0
WireConnection;16;1;11;2
WireConnection;13;0;11;1
WireConnection;13;1;12;1
WireConnection;15;0;11;1
WireConnection;15;1;12;1
WireConnection;127;0;79;0
WireConnection;127;1;107;0
WireConnection;127;2;115;0
WireConnection;127;3;123;0
WireConnection;102;0;66;1
WireConnection;102;1;66;2
WireConnection;75;0;102;0
WireConnection;75;1;260;0
WireConnection;105;0;109;0
WireConnection;105;1;254;0
WireConnection;106;0;108;0
WireConnection;106;1;105;0
WireConnection;108;0;104;1
WireConnection;108;1;104;2
WireConnection;124;0;120;1
WireConnection;124;1;120;2
WireConnection;125;0;119;1
WireConnection;125;1;119;2
WireConnection;121;0;125;0
WireConnection;121;1;258;0
WireConnection;122;0;124;0
WireConnection;122;1;121;0
WireConnection;113;0;117;0
WireConnection;113;1;257;0
WireConnection;114;0;116;0
WireConnection;114;1;113;0
WireConnection;116;0;112;1
WireConnection;116;1;112;2
WireConnection;117;0;111;1
WireConnection;117;1;111;2
WireConnection;136;0;132;0
WireConnection;115;0;114;0
WireConnection;107;0;106;0
WireConnection;79;0;78;0
WireConnection;77;0;67;1
WireConnection;77;1;67;2
WireConnection;132;0;133;0
WireConnection;123;0;122;0
WireConnection;109;0;103;1
WireConnection;109;1;103;2
WireConnection;256;0;251;0
WireConnection;257;0;256;0
WireConnection;257;1;256;0
WireConnection;258;0;251;0
WireConnection;258;1;251;0
WireConnection;253;0;251;0
WireConnection;254;0;273;0
WireConnection;254;1;253;0
WireConnection;260;0;259;0
WireConnection;260;1;251;0
WireConnection;259;0;251;0
WireConnection;273;0;251;0
WireConnection;137;0;136;0
WireConnection;137;1;127;0
WireConnection;138;0;137;0
WireConnection;139;0;138;0
WireConnection;264;0;262;0
WireConnection;264;2;275;0
WireConnection;264;3;281;0
WireConnection;275;0;274;4
WireConnection;133;0;129;1
WireConnection;133;1;129;2
WireConnection;78;0;77;0
WireConnection;78;1;75;0
WireConnection;57;0;59;0
WireConnection;57;1;65;0
WireConnection;57;2;280;0
WireConnection;0;0;57;0
WireConnection;280;1;264;0
WireConnection;280;2;139;0
WireConnection;59;0;58;0
ASEEND*/
//CHKSM=51A5C205498155DB2448ABED82A6FB8B73D4B849