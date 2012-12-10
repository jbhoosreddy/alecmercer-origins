//--------------------------------------------------------------------------------------
// SimpleShaders.fx
//
// This effect contains the techniques and shaders for simple rendering.  This file
// works in conjunction with AtgSimpleShaders.cpp and AtgSimpleShaders.h.
//
// Xbox Advanced Technology Group.
// Copyright (C) Microsoft Corporation. All rights reserved.
//--------------------------------------------------------------------------------------
shared float4x4 world_view_proj_matrix;
float4 simpleshader_constant_color = float4( 1, 1, 1, 1 );
sampler simpleshader_sampler;

struct VS_INPUT
{
	float4	vPos	: POSITION0;
	float4	vColor	: COLOR0;
};

struct VS_OUTPUT
{
	float4	Pos	    : POSITION;
	float4	Color   : COLOR;
};

struct PS_INPUT
{
	float4	Color	: COLOR;
};

struct VS_INPUT_TEX
{
	float4	vPos	: POSITION0;
	float4	vColor	: COLOR0;
	float2  vTex    : TEXCOORD0;
};

struct VS_OUTPUT_TEX
{
	float4	Pos	    : POSITION;
	float4	Color	: COLOR;
	float2  Tex     : TEXCOORD0;
};

struct PS_INPUT_TEX
{
	float4	Color	: COLOR;
	float2  Tex     : TEXCOORD0;
};

VS_OUTPUT vs_PassThru( VS_INPUT In )
{
	VS_OUTPUT Out;
	Out.Pos = In.vPos;
	Out.Color = In.vColor;
	return Out;	
};

VS_OUTPUT vs_Transform( VS_INPUT In )
{
	VS_OUTPUT Out;
	Out.Pos = mul( In.vPos, world_view_proj_matrix );
	Out.Color = In.vColor;
	return Out;
};

float4 vs_Transform_PositionOnly( float4 InPos : POSITION0 ) : POSITION
{
	return mul( InPos, world_view_proj_matrix );
};

float4 vs_PassThru_PositionOnly( float4 InPos : POSITION0 ) : POSITION
{
	return InPos;
};

VS_OUTPUT_TEX vs_PassThru_Tex( VS_INPUT_TEX In )
{
	VS_OUTPUT_TEX Out;
	Out.Pos = In.vPos;
	Out.Color = In.vColor;
	Out.Tex = In.vTex;
	return Out;	
};

VS_OUTPUT_TEX vs_Transform_Tex( VS_INPUT_TEX In )
{
	VS_OUTPUT_TEX Out;
	Out.Pos = mul( In.vPos, world_view_proj_matrix );
	Out.Color = In.vColor;
	Out.Tex = In.vTex;
	return Out;
};

float4 ps_ConstantColor() : COLOR
{
	return simpleshader_constant_color;
};

float4 ps_VertexColor( VS_OUTPUT In ) : COLOR
{
	return In.Color;
};

float4 ps_Texture( float2 InTex : TEXCOORD0 ) : COLOR
{
    return tex2D( simpleshader_sampler, InTex );
};

float4 ps_DepthTexture( float2 InTex : TEXCOORD0 ) : COLOR
{
    float4 depthsample = tex2D( simpleshader_sampler, InTex );
    float depth = depthsample.r;
    return float4( depth, depth, depth, 1 );
};

float4 ps_Texture_ModulateConstantColor( float2 InTex : TEXCOORD0 ) : COLOR
{
    float4 TexColor = tex2D( simpleshader_sampler, InTex );
    return TexColor * simpleshader_constant_color;
}

float4 ps_Texture_ModulateVertexColor( VS_OUTPUT_TEX In ) : COLOR
{
    float4 TexColor = tex2D( simpleshader_sampler, In.Tex );
    return TexColor * In.Color;
}

void ps_DownsampleDepth( in float2 vTexCoord : TEXCOORD0,
                        out float4 oColor : COLOR,
                        out float oDepth : DEPTH )
{
    // Fetch the four samples
    float4 SampledDepth;
    asm {
        tfetch2D SampledDepth.x___, vTexCoord, simpleshader_sampler, OffsetX = -0.5, OffsetY = -0.5, MinFilter=point, MagFilter=point
        tfetch2D SampledDepth._x__, vTexCoord, simpleshader_sampler, OffsetX =  0.5, OffsetY = -0.5, MinFilter=point, MagFilter=point
        tfetch2D SampledDepth.__x_, vTexCoord, simpleshader_sampler, OffsetX = -0.5, OffsetY =  0.5, MinFilter=point, MagFilter=point
        tfetch2D SampledDepth.___x, vTexCoord, simpleshader_sampler, OffsetX =  0.5, OffsetY =  0.5, MinFilter=point, MagFilter=point
    };
    
    // Find the maximum.
    SampledDepth.xy = max( SampledDepth.xy, SampledDepth.zw );
    SampledDepth.x = max( SampledDepth.x, SampledDepth.y );

    oColor = SampledDepth.x;
    oDepth = SampledDepth.x;
}

technique Transformed_DepthOnly
{
    pass 
    {
		VertexShader = compile vs_3_0 vs_Transform_PositionOnly();
		PixelShader = null;        
    }
}

technique Transformed_ConstantColor
{
	pass 
	{
		VertexShader = compile vs_3_0 vs_Transform();
		PixelShader = compile ps_3_0 ps_ConstantColor();
	}
}

technique Transformed_VertexColor
{
	pass 
	{
		VertexShader = compile vs_3_0 vs_Transform();
		PixelShader = compile ps_3_0 ps_VertexColor();
	}
}

technique Transformed_Textured
{
	pass 
	{
		VertexShader = compile vs_3_0 vs_Transform_Tex();
		PixelShader = compile ps_3_0 ps_Texture();
	}
}

technique Transformed_TextureConstantColor
{
	pass 
	{
		VertexShader = compile vs_3_0 vs_Transform_Tex();
		PixelShader = compile ps_3_0 ps_Texture_ModulateConstantColor();
	}
}

technique Transformed_TextureVertexColor
{
	pass 
	{
		VertexShader = compile vs_3_0 vs_Transform_Tex();
		PixelShader = compile ps_3_0 ps_Texture_ModulateVertexColor();
	}
}

technique PreTransformed_ConstantColor
{
	pass 
	{
		VertexShader = compile vs_3_0 vs_PassThru();
		PixelShader = compile ps_3_0 ps_ConstantColor();
	}
}

technique PreTransformed_VertexColor
{
	pass 
	{
		VertexShader = compile vs_3_0 vs_PassThru();
		PixelShader = compile ps_3_0 ps_VertexColor();
	}
}

technique PreTransformed_Textured
{
	pass 
	{
		VertexShader = compile vs_3_0 vs_PassThru_Tex();
		PixelShader = compile ps_3_0 ps_Texture();
	}
}

technique PreTransformed_DepthTextured
{
	pass 
	{
		VertexShader = compile vs_3_0 vs_PassThru_Tex();
		PixelShader = compile ps_3_0 ps_DepthTexture();
	}
}

technique PreTransformed_TextureConstantColor
{
	pass 
	{
		VertexShader = compile vs_3_0 vs_PassThru_Tex();
		PixelShader = compile ps_3_0 ps_Texture_ModulateConstantColor();
	}
}

technique PreTransformed_TextureVertexColor
{
	pass 
	{
		VertexShader = compile vs_3_0 vs_PassThru_Tex();
		PixelShader = compile ps_3_0 ps_Texture_ModulateVertexColor();
	}
}

technique PreTransformed_DepthOnly
{
	pass 
	{
		VertexShader = compile vs_3_0 vs_PassThru_PositionOnly();
		PixelShader = null;
	}
}

technique PreTransformed_DownsampleDepth
{
	pass 
	{
		VertexShader = compile vs_3_0 vs_PassThru_Tex();
		PixelShader = compile ps_3_0 ps_DownsampleDepth();
	}
}
