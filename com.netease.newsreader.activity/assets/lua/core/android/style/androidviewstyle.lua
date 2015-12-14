require "colortouch/style/PropertyDeclaration"

module("PropertyDeclaration", package.seeall)

PropertyDeclaration.registeUI('Container', 
                              'msgbg', 
                              {
                                 backgroundImage='bg_box.png'
--                                 backgroundEdgeInset=edgeInset{12,12,12,12},
})
PropertyDeclaration.registeUI('Button', 
                              'green', 
                              {
                                 states={
                                    hilighted={
--                                       backgroundImage='bk_download_chartlet_highlighted.png',
                                       backgroundImage='btn_green_pressed.png',
                                       
--                                       backgroundEdgeInset=edgeInset{5,5,5,5},
                                    },
                                    
                                    normal={
                                         backgroundImage='btn_green_normal.png',
                                    
--                                       backgroundImage='bk_download_chartlet_normal.png',
--                                       backgroundEdgeInset=edgeInset{5,5,5,5},
                                    },

                                    disabled={
                                       color=rgba{100,100,100,1},
                                    },

                                    fontSize=15,
                                    fontStyle='bold',
                                 },

})

PropertyDeclaration.registeUI('ImageView', 
                              'ico-ok',
                              {
                                 src='ico_ok.png'
})

PropertyDeclaration.registeUI('ImageView', 
                              'ico-share',
                              {
                                 src='ico_share.png',
})

