//
//  NeighborHoodCatTableView.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/25/23.
//

import SwiftUI
import SceneKit

struct NeighborHoodCatTableView: View {
    @ObservedObject var viewModel: NeighborhoodCatTables.ViewModel
    
    public init(cats: [ZipcodeCat]) {
        viewModel = .init(with: cats)
    }
    
    @ViewBuilder
    func listActionButton(cat: SceneCat) -> some View {
        
    }
    
    private var sceneView: some View {
        ZStack {
            SceneKitView(
                scene: viewModel.nonObservables.scene,
                onNodeSelected: { _ in },
                delegate: viewModel.nonObservables.sceneDelegate
            )
            .frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height * 0.25
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
            List {
                ForEach(viewModel.nonObservables.cats) {
                    listActionButton(cat: $0)
                }
            }
            sceneView
        }
        
    }
}

struct NeighborHoodCatTableView_Previews: PreviewProvider {
    static var previews: some View {
        NeighborHoodCatTableView(cats: ZipcodeCat.previews)
    }
}
