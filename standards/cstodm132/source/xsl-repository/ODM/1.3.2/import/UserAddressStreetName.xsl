<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:odm="http://www.cdisc.org/ns/odm/v1.3">
 
	<xsl:template name="UserAddressStreetName">	

      <xsl:element name="UserAddressStreetName">
         <xsl:element name="StreetName"><xsl:value-of select="."/></xsl:element> 
         <xsl:element name="FK_UserAddress"><xsl:value-of select="generate-id(..)"/></xsl:element>
      </xsl:element>

  </xsl:template>
</xsl:stylesheet>