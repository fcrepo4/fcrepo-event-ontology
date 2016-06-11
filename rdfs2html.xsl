<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dcterms="http://purl.org/dc/terms/">
  <xsl:output method="html"/>
  <xsl:variable name="about" select="/rdf:RDF/owl:Ontology[1]/@rdf:about"/>
  <xsl:variable name="title" select="/rdf:RDF/owl:Ontology[1]/dcterms:title"/>
  <xsl:variable name="comment" select="/rdf:RDF/owl:Ontology[1]/rdfs:comment"/>
  <xsl:variable name="publisher" select="/rdf:RDF/owl:Ontology[1]/dcterms:publisher/@rdf:resource"/>
  <xsl:variable name="seeAlso" select="/rdf:RDF/owl:Ontology[1]/rdfs:seeAlso/@rdf:resource"/>
  <xsl:variable name="versionInfo" select="/rdf:RDF/owl:Ontology[1]/owl:versionInfo"/>
  <xsl:variable name="priorVersion" select="/rdf:RDF/owl:Ontology[1]/owl:priorVersion/@rdf:resource"/>


  <xsl:template match="/rdf:RDF">
    <html>
      <head>
        <title><xsl:value-of select="$title"/></title>
        <style>
          body { width: 80%; margin: 0 auto; }
          header { text-align: center; }
          h1 { font-size: 2em; }
          h2 { font-size: 1.7em; }
          h3 { font-size: 1.4em; padding-top: 20px; }
          h4 { margin-bottom: 0.25em; }
          body { font-family: sans-serif; background: url(assets/cream_pixels.png);}
          table { width: 100%; margin: 15px 0; border-collapse: collapse; }
          tr { border: 1px solid #ccc; }
          th { background-color: #ddd; padding: 5px; font-size: 120%; text-align:center; font-weight: bold; }
          td { vertical-align: top; padding: 5px; border: 1px solid #ccc; }
          td:first-child { width: 150px; font-weight: bold; white-space: nowrap; }
          tr.about td:nth-child(2) { font-size: 120%; font-family: monospace; }
        </style>
      </head>
      <body>
        <header>
          <img src="assets/fedora_logo.png"/>
          <h1><xsl:value-of select="$title"/></h1>
            <table>
              <tr class="about">
                <td>Namespace</td>
                <td><xsl:value-of select="$about"/></td>
              </tr>
              <xsl:for-each select="/rdf:RDF/owl:Ontology/rdfs:comment">
                <tr class="comment">
                  <td>Description</td>
                  <td><xsl:value-of select="."/></td>
                </tr>
              </xsl:for-each>

              <xsl:if test="not(/rdf:RDF/owl:Ontology/owl:versionInfo = '')">
                <tr class="version">
                  <td>Version</td>
                  <td><xsl:value-of select="/rdf:RDF/owl:Ontology/owl:versionInfo"/></td>
                </tr>
              </xsl:if>
              <xsl:if test="not($priorVersion = '')">
                <tr class="version">
                  <td>Prior version</td>
                  <td>
                    <a>
                      <xsl:attribute name="href"><xsl:value-of select="$priorVersion"/></xsl:attribute>
                      <xsl:value-of select="$priorVersion"/>
                    </a>
                  </td>
                </tr>
              </xsl:if>
              <xsl:if test="$publisher != ''">
                <tr>
                  <td>Published by</td>
                  <td>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:value-of select="$publisher"/>
                      </xsl:attribute>
                      <xsl:value-of select="$publisher"/>
                    </a>
                  </td>
                </tr>
              </xsl:if>
              <xsl:if test="$seeAlso != ''">
                <tr>
                  <td>See Also</td>
                  <td>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:value-of select="$seeAlso"/>
                      </xsl:attribute>
                      <xsl:value-of select="$seeAlso"/>
                    </a>
                  </td>
                </tr>
              </xsl:if>
            </table>
        </header>

        <!-- table of contents -->
        <div class="table-of-contents">
          <h2>Table of Contents</h2>
          <xsl:if test="/rdf:RDF/rdfs:Class">
            <p><a href="#Classes">Classes</a></p>
          </xsl:if>

          <xsl:if test="/rdf:RDF/rdf:Property">
            <p><a href="#Properties">Properties</a></p>
          </xsl:if>
        </div>

        <article>
          <hr/>
          <h2>Entity Definitions</h2>
          <xsl:if test="/rdf:RDF/rdfs:Class">
            <a name="Classes"></a>
            <h3>Classes</h3>
            <xsl:for-each select="/rdf:RDF/rdfs:Class">
              <xsl:sort select="@rdf:about"/>
              <xsl:call-template name="description"/>
            </xsl:for-each>
          </xsl:if>

          <xsl:if test="/rdf:RDF/rdf:Property">
            <a name="Properties"></a>
            <h3>Properties</h3>
            <xsl:for-each select="/rdf:RDF/rdf:Property">
              <xsl:sort select="@rdf:about"/>
              <xsl:call-template name="description"/>
            </xsl:for-each>
          </xsl:if>

        </article>

      </body>
    </html>
  </xsl:template>

  <xsl:template name="description">
    <xsl:variable name="id" select="substring-after(@rdf:about,$about)"/>
    <div id="{$id}">
      <table>
        <tr>
          <th colspan="2">event:<xsl:value-of select="$id"/></th>
        </tr>
        <tr class="about">
          <td>URI</td>
          <td><xsl:value-of select="@rdf:about"/></td>
        </tr>

        <xsl:if test="rdfs:label">
          <tr class="label">
            <td>Label</td>
            <td><xsl:value-of select="rdfs:label"/></td>
          </tr>
        </xsl:if>
        <xsl:for-each select="rdfs:comment">
          <tr class="comment">
            <td>Description</td>
            <td><xsl:value-of select="."/></td>
          </tr>
        </xsl:for-each>
        <tr class="property">
          <td>Type</td>
          <td><xsl:value-of select="name()"/></td>
        </tr>
        <xsl:if test="rdfs:subClassOf">
          <tr class="property">
            <td>Subclass Of</td>
            <td>
              <xsl:for-each select="rdfs:subClassOf">
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="//*[contains(rdfs:domain/@rdf:resource,$id)]|//*[contains(rdfs:range/@rdf:resource,$id)]">
          <tr class="property">
            <td>Used With</td>
            <td>
              <xsl:for-each select="//*[contains(rdfs:domain/@rdf:resource,$id)]|//*[contains(rdfs:range/@rdf:resource,$id)]">
                <xsl:sort select="@rdf:about"/>
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="//*[rdf:type/@rdf:resource=concat($about,$id)]">
          <tr class="property">
            <td>Instances</td>
            <td>
              <xsl:for-each select="//*[rdf:type/@rdf:resource=concat($about,$id)]">
                <xsl:sort select="@rdf:about"/>
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="rdf:type">
          <tr class="property">
            <td>rdf:type</td>
            <td>
              <xsl:for-each select="rdf:type">
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="rdfs:domain">
          <tr class="property">
            <td>Domain</td>
            <td>
              <xsl:for-each select="rdfs:domain">
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="rdfs:range">
          <tr class="property">
            <td>Range</td>
            <td>
              <xsl:for-each select="rdfs:range">
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
      </table>
    </div>
  </xsl:template>

  <xsl:template name="link">
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="@rdf:about and contains(@rdf:about,$about)">
          <xsl:value-of select="substring-after(@rdf:about,$about)"/>
        </xsl:when>
        <xsl:when test="@rdf:resource and contains(@rdf:resource,$about)">
          <xsl:value-of select="substring-after(@rdf:resource,$about)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$id != ''">
        <a href="#{$id}">event:<xsl:value-of select="$id"/></a>
      </xsl:when>
      <xsl:when test="contains(@rdf:resource,'http://www.w3.org/2001/XMLSchema#')">
        <a href="{@rdf:resource}">xsd:<xsl:value-of select="substring-after(@rdf:resource,'#')"/></a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@rdf:resource"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
  </xsl:template>

</xsl:stylesheet>
