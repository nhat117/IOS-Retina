/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 3
 Nguyen Dinh Dang Nguyen (s3759957) – Project Manager
 Bui Minh Nhat (s3878174) – Technology Leader
 Nguyen Thanh Luan (s3757937) – Member
 Nguyen Phuoc Nhu Phuc (s3819660) – Member
 Created  date: 03/09/2022
 Last modified: 17/09/2022
 Acknowledgement: Acknowledge the resources that you use here.
 Tom's Huynh Lecture
 https://github.com/onevcat/Kingfisher
 https://developer.apple.com/documentation/coreml
 https://arxiv.org/abs/1801.04381
 https://firebase.google.com/docs/ios/setup
 https://adnan-tech.com/pick-image-from-gallery-and-upload-to-server-swiftui-and-php/
 https://developer.apple.com/documentation/corelocation
 https://designcode.io/swiftui-advanced-handbook-imagepicker
 */

import SwiftUI

//Overall Screen Route
enum  ScreenView: String, CaseIterable{
    case home
    case myStore
    case search
    case basket
    case menu
    case chat
}

struct NavigationBarView: View {
    // MARK: -View Properties
    @Binding var loginScreenViewSwitcher: LoginScreenSwitcher
    @State var currentView : ScreenView = .home
    @State var lastChosenTab : ScreenView = .home //Get last chosen tab to highlight tab on displaying subview
    @State var activatingNavTabs : [ScreenView] = [.home,.myStore,.chat,.basket,.menu]
    @Namespace var animation
    var body: some View {
        // MARK: Whole App body
        NavigationView{
            GeometryReader{geo in
                VStack (spacing: 0){
                    
                    ZStack {
                        switch (currentView){
                        case .home:
                            HomeView(currentView: $currentView)
                                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)) )
                        case .myStore:
                            MyStoreView(currentView: $currentView)
                                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)) )
                        case .search:
                            SearchView(currentView: $currentView)
                                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)) )
                        case .basket:
                            BasketView(currentView: $currentView)
                                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)) )
                        case .menu:
                            MenuView(loginScreenViewSwitcher : $loginScreenViewSwitcher)
                                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)) )
                        case .chat:
                            ChatListView(currentView: $currentView)
                                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)) )
                        }
                    }
                    .frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment:.top) // change this alignment to align text to top or center
                    
                    //bottom Nav bar
                    TabBar()
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                
            }
            .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .bottom)
            .background{
                Color.white
                    .ignoresSafeArea()
            }
        }
        
    }
    
    // MARK: Bottom tabs bar
    @ViewBuilder
    func TabBar() -> some View{
        ZStack{
            HStack(spacing :0){
                ForEach (activatingNavTabs, id:\.rawValue){tab in
                    let viewIcon = viewIcons[tab.rawValue] ?? "default"
                    ZStack {
                        // Change icon background color for search tab
                        if lastChosenTab == tab {
                            // This circle displays at choosing tab
                            Circle()
                                .fill(Color("PrimaryColor"))
                                .frame(width: 55, height: 55 )
                            
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                        // Icon
                        Image(systemName:viewIcon)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:  28, height: 28)
                            .foregroundColor(currentView == tab ? Color.white  : Color.gray.opacity(0.7) )
                    }
                    .frame(maxWidth:.infinity)
                    .padding(  0) // set padding for search icon
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // check tap gesture to change tab
                        withAnimation(.easeInOut){
                            currentView = tab
                            lastChosenTab = tab
                        }
                    }
                }
            }
            .padding([.top, .horizontal])
        }
        .background(Color.white)
    }
}

struct NavigationBarViewPreview: PreviewProvider {
    static var previews: some View {
        NavigationBarView(loginScreenViewSwitcher: .constant(.navBar))
    }
}
