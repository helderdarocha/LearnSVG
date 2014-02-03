<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/2000/svg"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:output method="xml" indent="yes" 
                doctype-public="-//W3C//DTD SVG 1.0//EN" 
                doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <svg width="100%" height="100%">
            <style>
                text {font-family: calibri, sans-serif}
            </style>
            <rect x="50" y="50" width="800" height="450" fill="white" stroke="gray" stroke-width="1" />
            <g x="70" y="40" transform="rotate(10)">
                <xsl:apply-templates />
            </g>
        </svg>
    </xsl:template>
    
    <xsl:template match="orbita[planeta]">
        <xsl:variable name="tamanho_barra" 
                      select="planeta/@diametrokm div (//planeta[not(@diametrokm &lt; //planeta/@diametrokm)]/@diametrokm)" />
        <text x="0"  y="{20 + (position() - 1)*40}" font-size="16"><xsl:value-of select="planeta/@nome"/></text>
        
        <rect x="80" y="{(position() - 1)*40}" 
              width="{$tamanho_barra*600}" height="30"
              fill="rgb({round(255 * $tamanho_barra)}, {round(255 * $tamanho_barra)}, {round(255 * $tamanho_barra)})"
              stroke="black" stroke-width="1"/>
        
        <text x="{$tamanho_barra*600 + 100}" y="{20 + (position() - 1)*40}"><xsl:value-of select="planeta/@diametrokm"/> km</text>
    </xsl:template>

</xsl:stylesheet>