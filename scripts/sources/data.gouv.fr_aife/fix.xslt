<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xsl xs fn">
    <xsl:output method="xml" encoding="UTF-8"/>
    <xsl:param name="date"/>

    <xsl:template match="/marches/marche[not(datePublicationDonnees)]">
        <marche>
            <xsl:apply-templates/>
            <datePublicationDonnees>
                <xsl:value-of select="$date"/>
            </datePublicationDonnees>
        </marche>
    </xsl:template>

    <xsl:template match="/marches/contrat-concession[not(datePublicationDonnees)]">
        <contrat-concession>
            <xsl:apply-templates/>
            <datePublicationDonnees>
                <xsl:value-of select="$date"/>
            </datePublicationDonnees>
        </contrat-concession>
    </xsl:template>

    <xsl:template match="/marches/marche/nature">
        <nature>
            <xsl:choose>
                <xsl:when test="text() = 'MARCHE'">
                    <xsl:text>Marché</xsl:text>
                </xsl:when>
                <xsl:when test="text() = 'ACCORD-CADRE'">
                    <xsl:text>Accord-cadre</xsl:text>
                </xsl:when>
                <xsl:when test="text() = 'MARCHE SUBSEQUENT'">
                    <xsl:text>Marché subséquent</xsl:text>
                </xsl:when>
            </xsl:choose>
        </nature>
    </xsl:template>

    <xsl:template match="/marches/marche/lieuExecution/typeCode">
        <typeCode>
            <xsl:choose>
                <xsl:when test="text() = 'CODE PAYS'">
                    <xsl:text>Code pays</xsl:text>
                </xsl:when>
                <xsl:when test="text() = 'CODE REGION'">
                    <xsl:text>Code région</xsl:text>
                </xsl:when>
                <xsl:when test="text() = 'CODE DEPARTEMENT'">
                    <xsl:text>Code département</xsl:text>
                </xsl:when>
                <xsl:when test="text() = 'CODE COMMUNE'">
                    <xsl:text>Code commune</xsl:text>
                </xsl:when>
                <xsl:when test="text() = 'CODE POSTAL'">
                    <xsl:text>Code postal</xsl:text>
                </xsl:when>
            </xsl:choose>
        </typeCode>
    </xsl:template>

    <!-- Deep copy template -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
