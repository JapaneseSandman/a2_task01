(: using Zorba, at command line type: 

zorba -q join.xq -f -z method=xml -z doctype-system="output.dtd" -o "output.xml" -i

:)

declare namespace functx = "http://www.functx.com";
declare function functx:if-empty
  ( $arg as item()? ,
    $value as item()* )  as item()* {

  if (string($arg) != '')
  then data($arg)
  else $value
 } ;


<authors>{

let $authors := doc("authors.xml")/authors/*

for $x in $authors

return 

<author>

{$x/*}


{


let $artworks := doc("artworks.xml")/artworks/*


let $artforms := distinct-values($artworks/form)


let $returned := (
 
  for $category in $artforms

 return
           <artworks form="{$category}">
           
           {
           
                for $y in $artworks
           
                where ($y/author/text() = $x/name/text()) and $y/form/text() = $category

                order by $y/date
 
                return <artwork date="{$y/date}">{($y/title, $y/technique, $y/location)}</artwork>
           
           }
             
           </artworks>   

)


for $item in $returned
where functx:if-empty($item, '') != ''
return $item



}


</author>


}

</authors> 