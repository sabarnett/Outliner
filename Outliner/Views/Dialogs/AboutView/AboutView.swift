//
// File: About.swift
// Package: Mac Template App
// Created by: Steven Barnett on 18/08/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AboutView: View {

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(nsImage: NSImage(named: "AppIcon")!)
                    .frame(width: 80, height: 80)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text("\(Bundle.main.appName)")
                        .font(.system(size: 30, weight: .bold))
                        .textSelection(.enabled)
                    
                    Text("Ver: \(Bundle.main.appVersionLong) (\(Bundle.main.appBuild)) ")
                        .font(.system(size: 16, weight: .bold))
                        .textSelection(.enabled)
                }
                
                Spacer()
            }
            .frame(width: 400)
            .padding()

            Text(Constants.appDescription)
                .font(.system(size: 14))
                .multilineTextAlignment(.leading)
                .lineLimit(5)
                .padding(.horizontal)

            Link(Constants.homeAddress,
                 destination: Constants.homeUrl )
            .padding(.horizontal)

            HStack {
                Spacer()
                Text(Bundle.main.copyright)
                    .font(.system(size: 10, weight: .thin))
                    .padding(8)
            }
        }
        .frame(width: 440, height: 300)
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
