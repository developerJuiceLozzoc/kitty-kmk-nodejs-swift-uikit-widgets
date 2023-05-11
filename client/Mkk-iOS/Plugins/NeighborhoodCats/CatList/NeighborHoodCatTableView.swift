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
    
    public init?(from aviewModel: NeighborhoodScene.ViewModel) {
        let cats = aviewModel.nonObservables.cats?.cats ?? []
        
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
    
    @ViewBuilder
    func listActionButton(cat: SceneCat) -> some View {
        HStack {
            Text(cat.catDetails?.breedid ?? "American Shorthair")
            Spacer()
            Image("chevron.down")
        }
        .onTapGesture {
            viewModel.didTap(cat: cat)
        }
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
                List {
                    ForEach(viewModel.nonObservables.cats) {
                        listActionButton(cat: $0)
                    }
                }
            }
            
            Spacer()
            sceneView
        }
        
    }
}

struct NeighborHoodCatTableView_Previews: PreviewProvider {
    static var cats = ZipcodeCat.previews
    static var viewModel: NeighborhoodScene.ViewModel {
        var viewModel: NeighborhoodScene.ViewModel = .init()
        viewModel.nonObservables.cats = .init(zipcode: "80304", cats: ZipcodeCat.previews)
        return viewModel
    }
    static var previews: some View {
        NeighborHoodCatTableView(from: viewModel)
    }
}
