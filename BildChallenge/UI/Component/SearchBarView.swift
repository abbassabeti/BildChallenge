//
//  SearchBar.swift
//  BildChallenge
//
//  Created by Abbas Sabeti on 31/12/2021.
//

import SwiftUI

struct SearchBarView: UIViewRepresentable {

    @Binding var text: String

    func makeUIView(context: UIViewRepresentableContext<SearchBarView>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBarView>) {
        uiView.text = text
    }

    func makeCoordinator() -> SearchBarView.Coordinator {
        return Coordinator(text: $text)
    }
}

extension SearchBarView {
    final class Coordinator: NSObject, UISearchBarDelegate {

        let text: Binding<String>

        init(text: Binding<String>) {
            self.text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text.wrappedValue = searchText
        }

        func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            searchBar.setShowsCancelButton(true, animated: true)
            return true
        }

        func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
            searchBar.setShowsCancelButton(false, animated: true)
            return true
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(true)
            searchBar.text = ""
            text.wrappedValue = ""
        }
    }
}
