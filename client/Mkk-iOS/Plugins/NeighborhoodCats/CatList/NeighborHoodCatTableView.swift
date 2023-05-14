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
        let config = KMKListLink.Configuration(
            titleStyle: .title3,
            title: ""
        ) {
            if let details = cat.catDetails {
                
                viewModel.didTap(cat: cat)
                self.handler?(details)
            }
        }
        
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
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.observables.minTimeCanRenderCat < .infinity {
                ScrollView {
                    ForEach(viewModel.nonObservables.cats) {
                        listActionButton(cat: $0)
                    }
                }
            }
            
            Spacer()
            sceneView
        }
        .onAppear {
            let api = KittyJsoner()
            api.getJsonByBreed(with: "norw") { result in
                switch result {
                case .success(let arr):
                    print(arr)
                case .failure(let err):
                    print(err)
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
