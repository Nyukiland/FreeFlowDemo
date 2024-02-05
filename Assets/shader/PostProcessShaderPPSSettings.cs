// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( PostProcessShaderPPSRenderer ), PostProcessEvent.AfterStack, "PostProcessShader", true )]
public sealed class PostProcessShaderPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Color 0" )]
	public ColorParameter _Color0 = new ColorParameter { value = new Color(0.4245283f,0.4101104f,0.4101104f,0.454902f) };
}

public sealed class PostProcessShaderPPSRenderer : PostProcessEffectRenderer<PostProcessShaderPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "PostProcessShader" ) );
		sheet.properties.SetColor( "_Color0", settings._Color0 );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
