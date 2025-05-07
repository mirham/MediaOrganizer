//
//  DropViewDelegate.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 30.09.2024.
//

import SwiftUI

struct DropViewDelegate<T: Element>: DropDelegate {
    @Binding var draggedItem: DraggableElement<T>?
    @Binding var items: [DraggableElement<T>]
    
    let item: DraggableElement<T>
    
    private let start = 0
    private let step = 1
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem = self.draggedItem else {
            return
        }
        
        let from = items.firstIndex(of: draggedItem) != nil ? items.firstIndex(of: draggedItem) : nil
        let to = items.firstIndex(of: item) != nil ? items.firstIndex(of: item)! : start
        
        withAnimation(.easeInOut) {
            if(from != nil) {                
                let from = items.firstIndex(of: draggedItem)
                let to = items.firstIndex(of: item)
                
                if(to == nil) {
                    items.remove(at: from!)
                }
                else {
                    self.items.move(fromOffsets: IndexSet(integer: from!), toOffset: to! > from! ? to! + 1 : to!)
                }
                
            }
            else {
                if (!items.contains(where: {Int(Date().timeIntervalSince($0.dateCreated))
                    < Constants.dragAndDropTimeToleranceInSeconds })) {
                    let item = draggedItem.clone()
                    items.insert(item, at: to == start ? to : to + step)
                }
            }
        }
    }
}
