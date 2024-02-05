// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Toonification"
{
	Properties
	{
		_Color("Color", Color) = (0.382031,0.6313389,0.8018868,0)
		_Color2("Color2", Color) = (0,0.5981312,1,0)
		_dotnumbers("dot numbers", Float) = 100
		_dotnumbers1("dot numbers", Float) = 100
		_Outlinesize("Outline size", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float3 viewDir;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _Color2;
		uniform float4 _Color;
		uniform float _dotnumbers;
		uniform float _Outlinesize;
		uniform float _dotnumbers1;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 appendResult144 = (float2(_dotnumbers , _dotnumbers));
			float2 break16_g11 = ( i.uv_texcoord * appendResult144 );
			float2 appendResult7_g11 = (float2(( break16_g11.x + ( 0.5 * step( 1.0 , ( break16_g11.y % 2.0 ) ) ) ) , ( break16_g11.y + ( 0.0 * step( 1.0 , ( break16_g11.x % 2.0 ) ) ) )));
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_objectlightDir = normalize( ObjSpaceLightDir( ase_vertex4Pos ) );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float fresnelNdotV114 = dot( ase_vertexNormal, ase_objectlightDir );
			float fresnelNode114 = ( 0.0 + 0.2 * pow( 1.0 - fresnelNdotV114, 3.2 ) );
			float temp_output_2_0_g11 = ( fresnelNode114 * 3.0 );
			float2 appendResult11_g12 = (float2(temp_output_2_0_g11 , temp_output_2_0_g11));
			float temp_output_17_0_g12 = length( ( (frac( appendResult7_g11 )*2.0 + -1.0) / appendResult11_g12 ) );
			float4 lerpResult106 = lerp( _Color2 , _Color , saturate( ( ( 1.0 - temp_output_17_0_g12 ) / fwidth( temp_output_17_0_g12 ) ) ));
			float4 color153 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV148 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode148 = ( 0.0 + _Outlinesize * pow( 1.0 - fresnelNdotV148, 5.0 ) );
			float4 lerpResult152 = lerp( lerpResult106 , color153 , floor( fresnelNode148 ));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float2 appendResult161 = (float2(_dotnumbers1 , _dotnumbers1));
			float2 break16_g15 = ( i.uv_texcoord * appendResult161 );
			float2 appendResult7_g15 = (float2(( break16_g15.x + ( 0.5 * step( 1.0 , ( break16_g15.y % 2.0 ) ) ) ) , ( break16_g15.y + ( 0.0 * step( 1.0 , ( break16_g15.x % 2.0 ) ) ) )));
			float fresnelNdotV154 = dot( reflect( ase_objectlightDir , ase_vertexNormal ), i.viewDir );
			float fresnelNode154 = ( 0.0 + 0.01 * pow( 1.0 - fresnelNdotV154, 5.92 ) );
			float temp_output_2_0_g15 = ( fresnelNode154 * 3.0 );
			float2 appendResult11_g16 = (float2(temp_output_2_0_g15 , temp_output_2_0_g15));
			float temp_output_17_0_g16 = length( ( (frac( appendResult7_g15 )*2.0 + -1.0) / appendResult11_g16 ) );
			float4 lerpResult164 = lerp( lerpResult152 , ase_lightColor , saturate( ( ( 1.0 - temp_output_17_0_g16 ) / fwidth( temp_output_17_0_g16 ) ) ));
			c.rgb = lerpResult164.rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.CommentaryNode;147;-2788.604,-824.5538;Inherit;False;346;755.9999;texture;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;146;-4019.878,-1226.727;Inherit;False;2732.848;1327.943;Comment;28;54;55;57;56;64;53;66;69;68;67;70;65;76;77;74;94;91;102;108;96;51;100;105;52;44;97;98;99;tri planar;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;90;-6237.579,-111.6904;Inherit;False;2029.281;432.0001;;8;12;21;27;19;6;13;20;5;Diffuse;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;12;-4851.807,-23.75946;Inherit;True;Square;-1;;1;fea980a1f68019543b2cd91d506986e8;0;1;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;21;-4644.806,-11.75945;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;19;-5742.808,-21.75947;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.39;False;2;FLOAT;0.68;False;3;FLOAT;1.36;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;6;-5992.579,-61.69043;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;13;-5152.808,-11.75945;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;20;-5419.808,22.2406;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjSpaceLightDirHlpNode;5;-6187.579,93.30975;Inherit;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-4450.295,-2.295867;Inherit;False;Diffuse;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;85;-5714.175,455.5992;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.39;False;2;FLOAT;0.68;False;3;FLOAT;1.36;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;86;-5963.946,415.6682;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;88;-5391.176,499.5994;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjSpaceLightDirHlpNode;89;-6158.947,570.6686;Inherit;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;-4421.665,475.0628;Inherit;False;DiffuseBis;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;81;-5905.489,593.925;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;83;-4843.177,447.5992;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;82;-4627.176,489.5993;Inherit;True;Square;-1;;2;fea980a1f68019543b2cd91d506986e8;0;1;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;87;-5124.176,465.5992;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.45;False;2;FLOAT;0.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;54;-3581.877,-661.5068;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;55;-3247.876,-704.5068;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;57;-3248.876,-508.5068;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;-3252.876,-610.5068;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;64;-3308.845,-1176.727;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;53;-2608.846,-1164.727;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NormalizeNode;66;-2856.844,-1168.727;Inherit;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-2214.876,-299.6358;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2222.547,-565.139;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-2227.601,-825.601;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-1844.945,-555.704;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;65;-3093.845,-1173.727;Inherit;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;76;-2417.287,-767.0624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;77;-2447.287,-327.0623;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;74;-2427.408,-550.506;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjSpaceLightDirHlpNode;102;-3659.13,-83.78363;Inherit;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalVertexDataNode;108;-3659.13,-268.7836;Inherit;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;51;-3969.878,-727.5068;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;100;-3334.682,-216.489;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.37;False;3;FLOAT;0.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-3033.13,-162.7836;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;52;-3634.246,-1176.027;Inherit;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;44;-1539.03,-510.2523;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-3008.034,-419.2859;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;100,100;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-3020.034,-612.2862;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;100,100;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-3015.034,-863.2867;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;100,100;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;94;-2720.604,-774.5538;Inherit;True;Dots Pattern;-1;;5;7d8d5e315fd9002418fb41741d3a59cb;1,22,0;5;21;FLOAT2;0,0;False;3;FLOAT2;8,8;False;2;FLOAT;1;False;4;FLOAT;0.5;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;91;-2734.079,-542.356;Inherit;True;Dots Pattern;-1;;7;7d8d5e315fd9002418fb41741d3a59cb;1,22,0;5;21;FLOAT2;0,0;False;3;FLOAT2;8,8;False;2;FLOAT;1;False;4;FLOAT;0.5;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;96;-2738.604,-322.5539;Inherit;True;Dots Pattern;-1;;9;7d8d5e315fd9002418fb41741d3a59cb;1,22,0;5;21;FLOAT2;0,0;False;3;FLOAT2;8,8;False;2;FLOAT;1;False;4;FLOAT;0.5;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;106;618.5658,-104.4709;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;23;91.2196,-235.7778;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;0;False;0;False;0.382031,0.6313389,0.8018868,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;107;88.56591,-410.471;Inherit;False;Property;_Color2;Color2;1;0;Create;True;0;0;0;False;0;False;0,0.5981312,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FloorOpNode;150;695.1106,272.9937;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;148;375.1107,271.9937;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;50.11079,411.9936;Inherit;False;Property;_Outlinesize;Outline size;4;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;152;998.1105,107.9938;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;153;645.1106,103.9938;Inherit;False;Constant;_OutlineColor;Outline Color;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;112;-902.5936,111.2704;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ObjSpaceLightDirHlpNode;111;-902.5936,296.2705;Inherit;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;157;16.11079,833.9937;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ReflectOpNode;158;114.4257,605.414;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ObjSpaceLightDirHlpNode;155;-279.8893,672.9937;Inherit;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalVertexDataNode;159;-269.5743,523.414;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;145;-376.1372,39.31942;Inherit;False;Property;_dotnumbers;dot numbers;2;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;144;-165.1375,30.9194;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;115;27.04828,23.79425;Inherit;True;Dots Pattern;-1;;11;7d8d5e315fd9002418fb41741d3a59cb;1,22,0;5;21;FLOAT2;0,0;False;3;FLOAT2;20,20;False;2;FLOAT;1;False;4;FLOAT;0.5;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;161;960.4393,882.3124;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;160;749.4387,892.0125;Inherit;False;Property;_dotnumbers1;dot numbers;3;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-157.4452,275.845;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;156;821.1107,475.9937;Inherit;True;Step Antialiasing;-1;;14;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;909.6746,691.1417;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;162;1159.725,628.4875;Inherit;True;Dots Pattern;-1;;15;7d8d5e315fd9002418fb41741d3a59cb;1,22,0;5;21;FLOAT2;0,0;False;3;FLOAT2;20,20;False;2;FLOAT;1;False;4;FLOAT;0.5;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;164;1419.675,257.1417;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;165;1159.675,415.1417;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.FresnelNode;154;446.1107,558.9937;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.01;False;3;FLOAT;5.92;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1723.439,-91.26218;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Toonification;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.FresnelNode;114;-484.9965,233.1397;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;3;FLOAT;3.2;False;1;FLOAT;0
WireConnection;12;2;13;0
WireConnection;21;0;12;0
WireConnection;19;0;6;0
WireConnection;19;4;5;0
WireConnection;13;0;20;0
WireConnection;20;0;19;0
WireConnection;27;0;21;0
WireConnection;85;0;86;0
WireConnection;85;4;81;0
WireConnection;88;0;85;0
WireConnection;84;0;82;0
WireConnection;81;0;89;0
WireConnection;83;0;87;0
WireConnection;82;2;83;0
WireConnection;87;0;88;0
WireConnection;54;0;51;0
WireConnection;55;0;54;0
WireConnection;55;1;54;1
WireConnection;57;0;54;1
WireConnection;57;1;54;2
WireConnection;56;0;54;0
WireConnection;56;1;54;2
WireConnection;64;0;52;0
WireConnection;53;0;66;0
WireConnection;66;0;65;0
WireConnection;69;0;77;0
WireConnection;69;1;53;0
WireConnection;68;0;74;0
WireConnection;68;1;53;1
WireConnection;67;0;76;0
WireConnection;67;1;53;2
WireConnection;70;0;67;0
WireConnection;70;1;68;0
WireConnection;70;2;69;0
WireConnection;65;0;64;0
WireConnection;76;0;91;0
WireConnection;77;0;91;0
WireConnection;74;0;91;0
WireConnection;100;0;108;0
WireConnection;100;4;102;0
WireConnection;105;0;100;0
WireConnection;44;0;70;0
WireConnection;97;0;57;0
WireConnection;98;0;56;0
WireConnection;99;0;55;0
WireConnection;94;3;99;0
WireConnection;94;2;105;0
WireConnection;91;3;98;0
WireConnection;91;2;105;0
WireConnection;96;3;97;0
WireConnection;96;2;105;0
WireConnection;106;0;107;0
WireConnection;106;1;23;0
WireConnection;106;2;115;0
WireConnection;150;0;148;0
WireConnection;148;2;151;0
WireConnection;152;0;106;0
WireConnection;152;1;153;0
WireConnection;152;2;150;0
WireConnection;158;0;155;0
WireConnection;158;1;159;0
WireConnection;144;0;145;0
WireConnection;144;1;145;0
WireConnection;115;3;144;0
WireConnection;115;2;113;0
WireConnection;161;0;160;0
WireConnection;161;1;160;0
WireConnection;113;0;114;0
WireConnection;156;1;154;0
WireConnection;163;0;154;0
WireConnection;162;3;161;0
WireConnection;162;2;163;0
WireConnection;164;0;152;0
WireConnection;164;1;165;0
WireConnection;164;2;162;0
WireConnection;154;0;158;0
WireConnection;154;4;157;0
WireConnection;0;13;164;0
WireConnection;114;0;112;0
WireConnection;114;4;111;0
ASEEND*/
//CHKSM=CBE14E360E93A8B887B3A4285533BBC16682A080