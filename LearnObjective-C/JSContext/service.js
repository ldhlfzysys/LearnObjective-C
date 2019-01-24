
var service = {
data:{
tapcount:1
}
}

Object.defineProperty(service,'data.tapcount',{
                      set:function(value){
                      console.log('hook set')
                      data.tapcount = value
                      },
                      get:function(){
                      console.log('hook get')
                      return data.tapcount
                      }
                      })

function data1(){
    console.log(service.data.tapcount)
    return 1
}
