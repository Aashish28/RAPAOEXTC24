extend view entity YR_YR_PRODUCTTP with 

composition [0..*] of YR_PRODBOM as ZZProdBomYZA
{
    _Extension.zz_review_yza as zz_review_yza,
    ZZProdBomYZA
}
