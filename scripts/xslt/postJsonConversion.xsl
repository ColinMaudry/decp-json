<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">

    <xsl:template match="/data">
        <marches>
            <xsl:apply-templates/>
        </marches>
    </xsl:template>
    <xsl:template match="marches[./_type/text() = 'Marché']">
        <marche>
            <xsl:apply-templates/>
            <titulaires>
                <xsl:apply-templates select="titulaires" mode="array"/>
            </titulaires>
            <modifications>
                <xsl:apply-templates select="modifications" mode="array"/>
            </modifications>
        </marche>
    </xsl:template>

    <xsl:template match="marches[./_type/text() = 'Contrat de concession']">
        <contrat-concession>
            <xsl:apply-templates/>
            <concessionnaires>
                <xsl:apply-templates select="concessionnaires" mode="array"/>
            </concessionnaires>
            <donneesExecution>
                <xsl:apply-templates select="donneesExecution" mode="array"/>
            </donneesExecution>
            <modifications>
                <xsl:apply-templates select="modifications" mode="array"/>
            </modifications>
        </contrat-concession>
    </xsl:template>

    <xsl:template match="titulaires" mode="array">
        <titulaire>
            <xsl:apply-templates/>
        </titulaire>
    </xsl:template>

    <xsl:template match="modifications" mode="array">
        <modification>
            <xsl:apply-templates/>
            <xsl:if test="titulaires">
                <titulaires>
                    <xsl:apply-templates select="titulaires" mode="array"/>
                </titulaires>
            </xsl:if>
        </modification>
    </xsl:template>

    <xsl:template match="concessionnaires" mode="array">
        <concessionnaire>
            <xsl:apply-templates/>
        </concessionnaire>
    </xsl:template>

    <xsl:template match="donneesExecution" mode="array">
        <donneesAnnuelles>
            <xsl:apply-templates/>
            <tarifs>
                <xsl:apply-templates select="tarifs" mode="array"/>
            </tarifs>
        </donneesAnnuelles>
    </xsl:template>

    <xsl:template match="tarifs" mode="array">
        <tarif>
            <xsl:apply-templates/>
        </tarif>
    </xsl:template>

    <xsl:template match="titulaires | modifications | concessionnaires | _type | donneesExecution | tarifs"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
