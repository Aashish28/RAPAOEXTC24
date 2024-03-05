extend view entity YC_YR_PRODUCTTP with {

  @UI.lineItem: [ {
  position: 80 ,
  importance: #MEDIUM,
  label: 'Review/Feedback'
  }, 
  { type: #FOR_ACTION, dataAction: 'zzaddReview', label: 'Add Review/FeedBack' }
  ]
  @UI.identification: [ {
  position: 80 ,
  label: 'Review/Feedback'
  } ]
  
    YR_PRODUCT.zz_review_yza as zz_review_yza,

    @UI.facet: [
      {
        id:            'Review',
        purpose:       #STANDARD,
        type:          #LINEITEM_REFERENCE,
        label:         'Review',
        position:      20,
        targetElement: 'ZZProdBomYZA'
      }
    ]
     YR_PRODUCT.ZZProdBomYZA : redirected to composition child YC_PRODBOM     
    
}
