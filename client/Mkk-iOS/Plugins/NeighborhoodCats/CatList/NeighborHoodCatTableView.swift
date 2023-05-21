//
//  NeighborHoodCatTableView.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/25/23.
//

import SwiftUI
import SceneKit

struct NeighborHoodCatTableView: View {
    @Environment(\.myCustomValue) var isLandscape: Bool
    @ObservedObject var viewModel: NeighborhoodCatTables.ViewModel
    
    var handler: ((ZipcodeCat) -> Void)?
    
    public init(from aviewModel: NeighborhoodScene.ViewModel, onNodeSelected: ((ZipcodeCat) -> Void)?){
        let cats = aviewModel.nonObservables.cats?.cats ?? []
        self.handler = onNodeSelected
        if aviewModel.nonObservables.tableViewModel == nil {
            let viewModel: NeighborhoodCatTables.ViewModel = .init(with: cats)
            self.viewModel = viewModel
            aviewModel.nonObservables.tableViewModel = viewModel
        } else if let viewModel = aviewModel.nonObservables.tableViewModel {
            self.viewModel = viewModel
        } else {
            viewModel = .init(with: [])
        }
    }
    
    func listActionButton(cat: SceneCat) -> KMKListLink {
        let longPressAction: () -> Void = {
            viewModel.didLongPress(cat: cat)
            if let details = cat.catDetails {
                self.handler?(details)
            }
        }
        let tapAction: () -> Void = {
            viewModel.didTap(with: cat)
        }
        let config = KMKListLink.Configuration(
            titleStyle: .title3,
            title: cat.catDetails?.breed.name ?? "",
            tapAction: tapAction,
            longPressAction: longPressAction
        )
            
            
        
        return KMKListLink(config: config)
    }
    
    var sceneFrame: CGSize {
        if isLandscape {
            return .init(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.25)
        } else {
            return .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.25)
        }
    }
    
    private var sceneView: some View {
        ZStack {
            SceneKitView(
                scene: viewModel.nonObservables.scene,
                onNodeSelected: { _ in },
                delegate: viewModel.nonObservables.sceneDelegate
            )
            .frame(
                width: sceneFrame.width,
                height: sceneFrame.height
            )
            .padding(.top, 16)
            activityIndicator
        }
    }
    
    var activityIndicator: some View {
        VStack {
            if viewModel.observables.isSceneLoading {
                KMKLoadingIndicator(bodyText: "Neighboorhood scene resources Loading")
            }
        }
    }
    
    @ViewBuilder
    func nav(for link: KMKListLink, breed: ZipcodeCat) -> some View {
        ZStack {
            NavigationLink(
                destination: VStack {
                    if let details = viewModel.detailsCatSelected {
                        detailsView(for: details)
                    } else {
                        EmptyView()
                    }
                },
                isActive: viewModel.bindingDetailsIsActive) {
                    Text("")
            }
            link
        }
    }

    @ViewBuilder
    func detailsView(for cat: ZipcodeCat) -> some View {
        ZipcodeCatDetailsView(kitty: cat)
    }
    
    var mainContent: some View {
        VStack(spacing: 0) {
            ScrollView {
                ForEach(viewModel.nonObservables.cats) { cat in
                    VStack(spacing: 0) {
                        var shouldShimmer: Bool {
                            if let lhs = viewModel.shimmeringTowardsCat,
                               let rhs = cat.catDetails
                            {
                                return lhs != rhs
                            }
                            return false
                        }
                        if let breed = cat.catDetails {
                            nav(for: listActionButton(cat: cat), breed: breed)
                                .redacted(reason: shouldShimmer ? .placeholder : [])
                        }
                        Spacer(minLength: 8)
                        Rectangle()
                            .fill(Color("list-kitty-name-gradient-end-color"))
                            .frame(width: sceneFrame.width * 0.8, height: 10)
                            .allowsHitTesting(false)
                            
                        Spacer(minLength: 8)
                    }
                    

                }
            }
            Spacer()
            sceneView
        }
    }
    
    var body: some View {
        if isLandscape {
            mainContent
        } else {
            NavigationView {
                mainContent
                    .onAppear {
                        viewModel.observables.shimmeringTowardsCat = nil
                    }
            }
        }
    }
}

struct NeighborHoodCatTableView_Previews: PreviewProvider {
    static var cats = ZipcodeCat.previews
    static var viewModel: NeighborhoodScene.ViewModel {
        let viewModel: NeighborhoodScene.ViewModel = .init()
        viewModel.nonObservables.cats = .init(zipcode: "80304", cats: ZipcodeCat.previews)
        return viewModel
    }
    static var previews: some View {
        NeighborHoodCatTableView(from: viewModel) { details in 
            
        }
    }
}
