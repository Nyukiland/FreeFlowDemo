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
	[Tooltip( "OutlineSize" )]
	public FloatParameter _OutlineSize = new FloatParameter { value = 1f };
	[Tooltip( "waveControl" )]
	public FloatParameter _waveControl = new FloatParameter { value = 0f };
}

public sealed class PostProcessShaderPPSRenderer : PostProcessEffectRenderer<PostProcessShaderPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "PostProcessShader" ) );
		sheet.properties.SetFloat( "_OutlineSize", settings._OutlineSize );
		sheet.properties.SetFloat( "_waveControl", settings._waveControl );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
