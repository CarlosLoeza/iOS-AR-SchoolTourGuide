//
//  VC+DijkstraComputation.swift
//  AR-SchoolTourGuide
//
//  Created by Carlos Loeza on 6/26/22.
//

import GameplayKit

extension ViewController{
    // find index of vertex with the shortest distance
    func minDistance(dist: [Int], sptSet: [Bool], size: Int)-> Int {
        // min: make it 1000 in order as a placeholder
        // min_index: index of the min index (placeholder:1111)
        var min = 1000
        var min_index = 1111
        
        // find the shortest distance edge and return index of vertex
        for i in 0...size-1 {
            // if not visited yet && shorter path than current min
            if (sptSet[i] == false && dist[i] <= min){
                min = dist[i]
                min_index = i
            }
        }
        return min_index
    }
    
    // print the shortest path
    func printPath(parent: [Int], j:Int){
        // if parent == -1, return since -1 represents source
        if (parent[j] == -1){
            return
        }
        // print path
        printPath(parent: parent, j: parent[j])
        print("\(j) ", terminator: " ")
    }
    
    // print entire solution showing intial vertex, distance traveled, and path taken from source vertex
    func printSolution(dist: [Int], parent:[Int], size: Int, src:Int){
        print("Vertex       Distance        Path")
        for i in 0...size-1 {
            print()
            print("\(src) -> \(i)         \(dist[i])              \(src) ", terminator: " ")
            printPath(parent: parent, j: i)
        }
        print()
    }
    

    func dijkstra(graph: [[Int]], src: Int, size: Int){
        // create our arrays
        // distance: distance traveled from source to destination
        // sptSet: true/false if vertex has been visited
        // parent: path taken
        var distance = [Int](repeating: 1000, count:size)
        var sptSet = [Bool](repeating: false, count: size)
        var parent = [Int](repeating: 0, count: size)
        parent[src] = -1
        distance[src] = 0
        
        // Update dist value of the adjacent vertices of the picked vertex.
        for i in 0...size-1 {
            // Pick the minimum distance vertex from the set of vertices not
            // yet processed. u is always equal to src in the first iteration.
            var minVertex = minDistance(dist: distance, sptSet: sptSet, size: size)
            
            // Mark the picked vertex as processed
            sptSet[minVertex] = true;
            
            // for loop to make sure we get the shortest distance to each vertex.
            for i in 0...size-1{
                // make sure sptSet[i] not visited, location not empty in our graph,
                // distance is not INFINITY meaning distance has been calculated,
                // make sure current path is smaller than existing distance[i]
                if(!sptSet[i] && (graph[minVertex][i] != 0) && distance[minVertex] != 1000
                   && distance[minVertex] + graph[minVertex][i] < distance[i]){
                    distance[i] = distance[minVertex] + graph[minVertex][i]
                    parent[i] = minVertex;
                }
            }
        }
    
        // print the constructed distance array
        printSolution(dist: distance, parent: parent, size: size, src: src)
    }
    
}
