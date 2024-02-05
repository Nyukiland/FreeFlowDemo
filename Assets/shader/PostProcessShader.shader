// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PostProcessShader"
{
	Properties
	{
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
			
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;


			
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
				float2 appendResult133 = (float2(ase_ppsScreenPosFragNorm.x , ase_ppsScreenPosFragNorm.y));
				float2 appendResult134 = (float2(_MainTex_TexelSize.x , _MainTex_TexelSize.y));
				float eyeDepth132 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( ( appendResult133 + ( appendResult134 * float2( 0,0 ) ) ), 0.0 , 0.0 ).xy ));
				float2 appendResult77 = (float2(ase_ppsScreenPosFragNorm.x , ase_ppsScreenPosFragNorm.y));
				float2 appendResult102 = (float2(_MainTex_TexelSize.x , _MainTex_TexelSize.y));
				float eyeDepth79 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( ( appendResult77 + ( appendResult102 * float2( -1,1 ) ) ), 0.0 , 0.0 ).xy ));
				float2 appendResult108 = (float2(ase_ppsScreenPosFragNorm.x , ase_ppsScreenPosFragNorm.y));
				float2 appendResult109 = (float2(_MainTex_TexelSize.x , _MainTex_TexelSize.y));
				float eyeDepth107 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( ( appendResult108 + ( appendResult109 * float2( 1,-1 ) ) ), 0.0 , 0.0 ).xy ));
				float2 appendResult124 = (float2(ase_ppsScreenPosFragNorm.x , ase_ppsScreenPosFragNorm.y));
				float2 appendResult125 = (float2(_MainTex_TexelSize.x , _MainTex_TexelSize.y));
				float eyeDepth123 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( ( appendResult124 + ( appendResult125 * float2( 1,1 ) ) ), 0.0 , 0.0 ).xy ));
				float2 appendResult116 = (float2(ase_ppsScreenPosFragNorm.x , ase_ppsScreenPosFragNorm.y));
				float2 appendResult117 = (float2(_MainTex_TexelSize.x , _MainTex_TexelSize.y));
				float eyeDepth115 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( ( appendResult116 + ( appendResult117 * float2( -1,-1 ) ) ), 0.0 , 0.0 ).xy ));
				float4 lerpResult57 = lerp( tex2D( _MainTex, uv_MainTex ) , color65 , saturate( floor( ( ( eyeDepth132 * -4.0 ) + ( eyeDepth79 + eyeDepth107 + eyeDepth123 + eyeDepth115 ) ) ) ));
				

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
Node;AmplifyShaderEditor.CommentaryNode;149;-2153.122,1671.011;Inherit;False;2040.252;2448.913;Comment;26;104;126;127;110;109;108;107;106;105;103;123;122;121;125;119;124;120;118;117;116;115;114;113;112;111;148;allSide;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;148;-2064.773,1808.733;Inherit;False;1523.487;654.4675;the image depth but slightly to the side;8;67;78;79;77;66;102;75;101;side;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;147;-1740.804,1018.205;Inherit;False;1419.365;584.2654;;9;128;129;130;131;132;133;134;135;136;Base Outline;1,1,1,1;0;0
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
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;12;-1154.329,331.6404;Inherit;False;0;0;_MainTex_TexelSize;Shader;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;11;-1151.329,148.6405;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-857.33,254.6404;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-852.3625,487.6405;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-577.3626,269.6404;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-585.3626,483.6405;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;137;-124.6459,1622.737;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;57;443.8896,1464.859;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;59;97.1434,1170.942;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;58;-139.2034,1174.617;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;65;-150.793,1352.206;Inherit;False;Constant;_Color1;Color 1;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;632.7517,1555.981;Float;False;True;-1;2;ASEMaterialInspector;0;8;PostProcessShader;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;7;False;;False;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.FloorOpNode;138;48.21753,1678.07;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;139;241.9175,1719.67;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;128;-1690.804,1251.205;Inherit;False;0;0;_MainTex_TexelSize;Shader;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;129;-1687.804,1068.205;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-1291.791,1291.479;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;131;-1022.792,1234.479;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenDepthNode;132;-821.7917,1234.479;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;133;-1351.791,1091.479;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;134;-1456.678,1270.471;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-499.4387,1284.257;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-4;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;135;-1504.678,1441.471;Inherit;False;Constant;_Vector4;Vector 0;1;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;127;-329.0296,1953.917;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;67;-1649.299,1858.733;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-984.2855,2025.006;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenDepthNode;79;-783.2855,2025.006;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;77;-1313.286,1882.006;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;66;-1966.9,2059.933;Inherit;False;0;0;_MainTex_TexelSize;Shader;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;102;-1732.773,2079.198;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-1479.651,2089.72;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;101;-2014.773,2302.195;Inherit;False;Constant;_Outlineoffset;Outline offset;1;0;Create;True;0;0;0;False;0;False;-1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;111;-1807.443,3238.265;Inherit;False;0;0;_MainTex_TexelSize;Shader;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;112;-1804.443,3055.265;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-1408.431,3278.539;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;114;-1139.432,3221.539;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenDepthNode;115;-938.4313,3221.539;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;116;-1468.431,3078.539;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;117;-1573.317,3257.53;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;118;-1621.317,3428.529;Inherit;False;Constant;_Vector2;Vector 2;1;0;Create;True;0;0;0;False;0;False;-1,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;124;-1473.534,3595.939;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenDepthNode;123;-943.5353,3738.939;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;103;-1769.972,2753.692;Inherit;False;0;0;_MainTex_TexelSize;Shader;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-1370.959,2793.966;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-1101.959,2736.966;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenDepthNode;107;-900.9606,2736.966;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;108;-1430.959,2593.965;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;109;-1535.845,2772.957;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;110;-1583.845,2943.957;Inherit;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;0;False;0;False;1,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;126;-1626.42,3945.929;Inherit;False;Constant;_Vector3;Vector 3;1;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScreenPosInputsNode;104;-1766.972,2570.69;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;120;-1809.547,3572.666;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;119;-1812.547,3755.666;Inherit;False;0;0;_MainTex_TexelSize;Shader;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;125;-1578.42,3774.93;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;-1413.535,3795.939;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;122;-1144.535,3738.939;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
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
WireConnection;13;0;11;1
WireConnection;13;1;12;1
WireConnection;15;0;11;1
WireConnection;15;1;12;1
WireConnection;14;0;13;0
WireConnection;14;1;11;2
WireConnection;16;0;15;0
WireConnection;16;1;11;2
WireConnection;137;0;136;0
WireConnection;137;1;127;0
WireConnection;57;0;59;0
WireConnection;57;1;65;0
WireConnection;57;2;139;0
WireConnection;59;0;58;0
WireConnection;0;0;57;0
WireConnection;138;0;137;0
WireConnection;139;0;138;0
WireConnection;130;0;134;0
WireConnection;130;1;135;0
WireConnection;131;0;133;0
WireConnection;131;1;130;0
WireConnection;132;0;131;0
WireConnection;133;0;129;1
WireConnection;133;1;129;2
WireConnection;134;0;128;1
WireConnection;134;1;128;2
WireConnection;136;0;132;0
WireConnection;127;0;79;0
WireConnection;127;1;107;0
WireConnection;127;2;123;0
WireConnection;127;3;115;0
WireConnection;78;0;77;0
WireConnection;78;1;75;0
WireConnection;79;0;78;0
WireConnection;77;0;67;1
WireConnection;77;1;67;2
WireConnection;102;0;66;1
WireConnection;102;1;66;2
WireConnection;75;0;102;0
WireConnection;75;1;101;0
WireConnection;113;0;117;0
WireConnection;113;1;118;0
WireConnection;114;0;116;0
WireConnection;114;1;113;0
WireConnection;115;0;114;0
WireConnection;116;0;112;1
WireConnection;116;1;112;2
WireConnection;117;0;111;1
WireConnection;117;1;111;2
WireConnection;124;0;120;1
WireConnection;124;1;120;2
WireConnection;123;0;122;0
WireConnection;105;0;109;0
WireConnection;105;1;110;0
WireConnection;106;0;108;0
WireConnection;106;1;105;0
WireConnection;107;0;106;0
WireConnection;108;0;104;1
WireConnection;108;1;104;2
WireConnection;109;0;103;1
WireConnection;109;1;103;2
WireConnection;125;0;119;1
WireConnection;125;1;119;2
WireConnection;121;0;125;0
WireConnection;121;1;126;0
WireConnection;122;0;124;0
WireConnection;122;1;121;0
ASEEND*/
//CHKSM=5811919FBEAC0150AB51EBD36B5C5D2C5AA02D0F