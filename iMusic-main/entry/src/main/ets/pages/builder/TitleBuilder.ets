@Builder
export function TitleBuilder(title:string){
  Row(){
    Text(title)
      .fontSize(18)
      .fontColor('#fff')
      .fontWeight(600)
      .layoutWeight(1)
    Image($r('app.media.more'))
      .width(18)
      .fillColor('#fff')
  }
}


