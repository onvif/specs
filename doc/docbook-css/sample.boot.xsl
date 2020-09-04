<xsl:transform
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    
    <xsl:output method="html" indent="no"/>
    <xsl:template match="/"> 
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html" />
                <script type="text/javascript" language="javascript"
                    src="../Saxonce/Saxonce.nocache.js"/>
                
                <script>
                    var onSaxonLoad = function() {
                    Saxon.run( {
                    source:     location.href,
                    logLevel:   "SEVERE",
                    stylesheet: "docbook-css/docbook.xsl"
                    });
                    }
                </script>
                
            </head>
            <!-- these elements are required also -->
            <body><p></p></body>
        </html>    
    </xsl:template>
    
</xsl:transform>