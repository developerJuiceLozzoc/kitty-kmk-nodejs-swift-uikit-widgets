//
//  ListNeighborhoodCatsView.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/10/23.
//

import SwiftUI

struct ListNeighborhoodCatsView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

/*
 
 there will be several,2-5 cats in the neighborhood that are created and exist.
 every month they will be refreshed, unless 4-5 cats remain, then they will form family.
 
 how do you attrack them? you need to have the correct specific toy set to aquire them/attract. You can always dismiss acat if you did not wish to receive them.
 
 so on this screen you will have a list of cats, and when you successfuly attrack one you can enter a navigation view to adopt or not addopt.
 
 possibly using sprite kit i can animate some static stock photos of cats of them bouncing around in a circle, and then there will be an area somewhere else representing your porch where they found the toys they wanted.
 
 My Porch.
 
 when you click on a cat bouncing around in the circle then it will present a sheet? yes a sheet with details that can be dismissed.
 
 */

struct ListNeighborhoodCatsView_Previews: PreviewProvider {
    static var previews: some View {
        ListNeighborhoodCatsView()
    }
}
