#include "BitmapCommon.fxh"

void BasicPixelShader(
    in float4 multiplyColor : COLOR0, 
    in float4 addColor : COLOR1, 
    in float2 texCoord : TEXCOORD0,
    in float2 texTL : TEXCOORD1,
    in float2 texBR : TEXCOORD2,
    out float4 result : COLOR0
) {
    texCoord = clamp(texCoord, texTL, texBR);
	addColor.rgb *= addColor.a;
	addColor.a = 0;

	result = multiplyColor * tex2D(TextureSampler, texCoord);
	result += (addColor * result.a);

    const float discardThreshold = (1.0 / 255.0);
    if (result.a < discardThreshold)
        discard;
}

technique WorldSpaceBitmapTechnique
{
    pass P0
    {
        vertexShader = compile vs_1_1 WorldSpaceVertexShader();
        pixelShader = compile ps_2_0 BasicPixelShader();
    }
}

technique ScreenSpaceBitmapTechnique
{
    pass P0
    {
        vertexShader = compile vs_1_1 ScreenSpaceVertexShader();
        pixelShader = compile ps_2_0 BasicPixelShader();
    }
}