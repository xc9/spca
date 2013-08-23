function [ rst ] = parseNSFXML( filename )
    x=xmlread(filename);
    rst.title = char(x.getChildNodes.item(0).getChildNodes.item(1).getElementsByTagName('AwardTitle').item(0).getTextContent);
    rst.abstract = stemword(char(x.getChildNodes.item(0).getChildNodes.item(1).getElementsByTagName('AbstractNarration').item(0).getTextContent));
    try
        rst.sumcode=char(x.getChildNodes.item(0).getChildNodes.item(1).getElementsByTagName('ProgramElement').item(0).getElementsByTagName('Code').item(0).getTextContent);
        rst.sumtext=char(x.getChildNodes.item(0).getChildNodes.item(1).getElementsByTagName('ProgramElement').item(0).getElementsByTagName('Text').item(0).getTextContent);
    catch
        rst.sumcode = 'unavailable';
        rst.sumtext = 'unavailable';
    end
    
end

