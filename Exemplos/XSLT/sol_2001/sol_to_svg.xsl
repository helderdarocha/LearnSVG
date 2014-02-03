<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:decimal-format decimal-separator="," grouping-separator="."/>
    
    <xsl:output method="xml" indent="yes" 
                doctype-public="-//W3C//DTD SVG 1.0//EN" 
                doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>
    <xsl:strip-space elements="*"/>
    
    <!-- PASTA ONDE ESTAO AS IMAGENS - PREFIRA USAR UM CAMINHO ABSOLUTO (alguns browsers nao funcionam com caminhos relativos) -->
    <xsl:param name="uribase"><![CDATA[../imagens]]></xsl:param>
    
    <!-- Diametro do sol -->
    <xsl:variable name="maiorDiametro" select="//*[@diametrokm][not(@diametrokm &lt; //*/@diametrokm)]/@diametrokm" />
    <!-- Diametro de jupiter -->
    <xsl:variable name="maiorDiametroPlaneta" select="//planeta[@diametrokm][not(@diametrokm &lt; //planeta/@diametrokm)]/@diametrokm" />
    
    <!-- Parametros que podem ser passados para de selecao de dados -->
    <xsl:param name="maxDiametro" select="$maiorDiametro" /> <!-- <xsl:param name="maxDiametro" select="$maiorDiametro | $maiorDiametroPlaneta | numero" /> -->
    <xsl:param name="minDiametro" select="500" />

    <!-- Parametros de estilo -->
    <xsl:param name="altura">783px</xsl:param>
    <xsl:param name="largura">875px</xsl:param>
    <xsl:param name="alturaViewBox">900</xsl:param>
    <xsl:param name="larguraViewBox">1000</xsl:param>
    <xsl:param name="larguraNome">110</xsl:param>
    <xsl:param name="larguraValor">100</xsl:param>
    <xsl:param name="espacoEntreItens">10</xsl:param>
    <xsl:param name="alturaCabecalho">90</xsl:param>
    <xsl:param name="alturaLegenda">80</xsl:param>
    <xsl:param name="corEstrela">rgb(255,180,50)</xsl:param>
    <xsl:param name="corPlaneta">rgb(100,100,255)</xsl:param> <!-- ex: red, #fff, #FF0000 -->
    <xsl:param name="corSatelite">rgb(255,100,100)</xsl:param>
    <xsl:param name="corAsteroide">rgb(100,255,100)</xsl:param>
    <xsl:param name="alturaImagem">200</xsl:param>
    <xsl:param name="larguraImagem">200</xsl:param>

    <xsl:param name="titulo">Corpos do sistema solar</xsl:param>

    <!-- Calculo das dimensoes do grafico -->
    <xsl:variable name="itensMostrados" select="//*[@diametrokm &gt; $minDiametro][@diametrokm &lt;= $maxDiametro]" />
    <xsl:variable name="maiorDiametroMostrado" select="$itensMostrados[@diametrokm][not(@diametrokm &lt; $itensMostrados/@diametrokm)]/@diametrokm" />
    <xsl:variable name="numeroDeItens" select="count($itensMostrados)" />
    <xsl:variable name="alturaGrafico" select="$alturaViewBox - ($alturaCabecalho + $alturaLegenda)" />
    <xsl:variable name="alturaBarra" select="$alturaGrafico div $numeroDeItens - $espacoEntreItens" />
    <xsl:variable name="alturaItem" select="$alturaBarra + $espacoEntreItens" />
    <xsl:variable name="maiorBarra" select="$larguraViewBox - ($larguraNome + $larguraValor + 20)" />
    
    <xsl:template match="/">
        <svg height="{$altura}" width="{$largura}" viewBox="0 0 {$larguraViewBox} {$alturaViewBox}">
            <style type="text/css">
                text {font-family: calibri, sans-serif;}
            </style>
            <title><xsl:value-of select="$titulo"/></title>
            <defs>
                <filter id="sombra">
                    <feGaussianBlur in="SourceGraphic" stdDeviation="7" />
                </filter>
                
                <rect id="tipoBarra" height="20" width="20" />
                <g id="legenda" style="font-size:12pt">
                    <text y="15" font-weight="bold" textLength="110">LEGENDA</text>
                    <use xlink:href="#tipoBarra" x="130" fill="{$corEstrela}" /><text x="160" y="15">Estrela</text>
                    <use xlink:href="#tipoBarra" x="230" fill="{$corPlaneta}" /><text x="260" y="15">Planeta*</text>
                    <use xlink:href="#tipoBarra" x="330" fill="{$corSatelite}" /><text x="360" y="15">Satelite</text>
                    <use xlink:href="#tipoBarra" x="430" fill="{$corAsteroide}" /><text x="460" y="15">Asteroide*</text>
                    <text y="40" font-size="12pt">* de acordo com convencoes anteriores a 2006.</text>
                </g>
                <g id="titulo">
                    <text y="30" font-size="24pt"><xsl:value-of select="$titulo"/></text>
                    <text y="50" font-size="12pt">com diametro entre <xsl:value-of select="format-number($minDiametro,'###.###')"/> e <xsl:value-of select="format-number($maxDiametro,'###.###')"/> km</text>
                </g>
                <g id="grafico">
                    <xsl:apply-templates />
                </g>
                <g id="imagens">
                    <xsl:apply-templates select="//imagem" />
                </g>
            </defs>
            
            <use xlink:href="#titulo"  transform="translate(20,10)"/>
            <use xlink:href="#grafico" transform="translate(20,{$alturaCabecalho + 10})"/>
            <use xlink:href="#legenda" transform="translate(20,{$alturaGrafico + $alturaCabecalho + 20})"/>
            <use xlink:href="#imagens" transform="translate({$larguraViewBox - ($larguraImagem + 10)},{$alturaViewBox - ($alturaImagem + $alturaLegenda + 10)})" />
        </svg>
    </xsl:template>
    
    <xsl:template match="sistemaEstelar">
        <xsl:for-each select="$itensMostrados">
            <xsl:sort select="@diametrokm" order="descending" data-type="number"/>
            <g>
                <xsl:attribute name="id">
                    <xsl:choose>
                        <xsl:when test="imagem">
                            <xsl:value-of select="substring-before(imagem/@href, '.')"/>
                        </xsl:when>
                        <xsl:when test="self::estrela">
                            <xsl:value-of select="substring-before(../imagem/@href, '.')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@id"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <title>
                    <xsl:if test="self::satelite">
                        <xsl:text>Satelite de </xsl:text><xsl:value-of select="../@nome"/>
                    </xsl:if>
                    <xsl:if test="self::planeta">
                        <xsl:value-of select="count(preceding::orbita[not(asteroide)]) + 1"/><xsl:text>o. </xsl:text>
                        <xsl:text>planeta*</xsl:text>
                    </xsl:if>
                </title>
                <desc>
                    <xsl:if test="self::planeta">
                        <xsl:text>Raio medio da orbita: </xsl:text><xsl:value-of select="../@raioMedUA"/><xsl:text> UA. </xsl:text>
                    </xsl:if>
                    <xsl:if test="self::satelite">
                        <xsl:text>Raio medio da orbita: </xsl:text><xsl:value-of select="format-number(@raioMedOrbitakm,'###.###')"/><xsl:text> km. </xsl:text>
                    </xsl:if>
                    <xsl:if test="@anoDescobrimento">
                        <xsl:text>Descoberto em </xsl:text><xsl:value-of select="@anoDescobrimento"/><xsl:text>.</xsl:text>
                    </xsl:if>
                </desc>
                <text font-size="12pt" x="0"   y="{$alturaItem div 2 + (position() - 1)*$alturaItem}"><xsl:value-of select="position()"/><xsl:text>. </xsl:text><xsl:value-of select="@nome"/></text>
                <rect x="{$larguraNome}" y="{(position() - 1) * $alturaItem}" width="{(@diametrokm div $maiorDiametroMostrado)*$maiorBarra}" height="{$alturaBarra}">
                    <xsl:attribute name="fill">
                        <xsl:if test="self::planeta"><xsl:value-of select="$corPlaneta"/></xsl:if>
                        <xsl:if test="self::asteroide"><xsl:value-of select="$corAsteroide"/></xsl:if>
                        <xsl:if test="self::satelite"><xsl:value-of select="$corSatelite"/></xsl:if>
                        <xsl:if test="self::estrela"><xsl:value-of select="$corEstrela"/></xsl:if>
                    </xsl:attribute>
                </rect>
                <text font-size="12pt" x="{(@diametrokm div $maiorDiametroMostrado)*$maiorBarra + $larguraNome + 10}" y="{$alturaItem div 2 + (position() - 1)*$alturaItem}"><xsl:value-of select="format-number(@diametrokm,'###.###')"/> km</text>
            </g>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="imagem">
        <g opacity="0.0">
            <rect x="-2" y="-2" height="{$alturaImagem+4}" width="{$larguraImagem+4}" fill="yellow" filter="url(#sombra)" />
            <image xlink:href="{concat($uribase, '/', @href)}" x="0" y="0" height="{$alturaImagem}" width="{$larguraImagem}" />
            <animate attributeName="opacity" from="0.0" to="1.0" begin="{substring-before(@href, '.')}.mouseover" dur="1s" fill="freeze"/>
            <animate attributeName="opacity" from="1.0" to="0.0" begin="{substring-before(@href, '.')}.mouseout"  dur="1s" fill="freeze"/>
        </g>
    </xsl:template>
</xsl:stylesheet>