<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xsl xs fn">
    <xsl:output method="xml" encoding="UTF-8"/>
    <xsl:param name="date"/>



<!-- If there was already a datePublicationDonnees, ignore all but first one. -->
    <xsl:template match="datePublicationDonnees[preceding-sibling::datePublicationDonnees]"/>
<!--
    <xsl:template match="/marches/contrat-concession[count(datePublicationDonnees) > 1]">
        <contrat-concession>
            <xsl:apply-templates/>
            <datePublicationDonnees>
                <xsl:value-of select="$date"/>
            </datePublicationDonnees>
        </contrat-concession>
    </xsl:template> -->

    <!-- Deep copy template -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
