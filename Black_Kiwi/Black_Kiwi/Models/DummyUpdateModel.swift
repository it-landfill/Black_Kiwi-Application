//
//  DummyUpdateModel.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 28/10/22.
//

import Foundation
import CoreLocation

class DummyUpdateModel {
    
    enum NoiseDistribution {
        case uniform
        case gaussian
        case poisson
        case triangular
    }
    
    // Universal parameter
    let radius: Double
    let numberOfDummies: Int
    let trueLocation: CLLocationCoordinate2D
    let noiseDistribution: NoiseDistribution
    
    // Poisson parameter
    let lambda: Double
    
    // Triangular parameter
    let min: Double
    let max: Double
    let mode: Double
    
    // Gaussian parameter
    let mean: Double
    let standard_deviation: Double
    
    // Constructors
    
    // Uniform distribution constructor
    init(radius: Double, numberOfDummies: Int, trueLocation: CLLocationCoordinate2D) {
        self.noiseDistribution = .uniform
        self.radius = radius
        self.numberOfDummies = numberOfDummies
        self.trueLocation = trueLocation
        self.lambda = 0
        self.min = 0
        self.max = 0
        self.mode = 0
        self.mean = 0
        self.standard_deviation = 0
    }
    
    // Poisson distribution constructor
    init(radius: Double, numberOfDummies: Int, trueLocation: CLLocationCoordinate2D, lambda: Double) {
        self.noiseDistribution = .poisson
        self.radius = radius
        self.numberOfDummies = numberOfDummies
        self.trueLocation = trueLocation
        self.lambda = lambda
        self.min = 0
        self.max = 0
        self.mode = 0
        self.mean = 0
        self.standard_deviation = 0
    }
    
    // Triangular distribution constructor
    init(radius: Double, numberOfDummies: Int, trueLocation: CLLocationCoordinate2D, min: Double, max: Double, mode: Double) {
        self.noiseDistribution = .triangular
        self.radius = radius
        self.numberOfDummies = numberOfDummies
        self.trueLocation = trueLocation
        self.lambda = 0
        self.min = min
        self.max = max
        self.mode = mode
        self.mean = 0
        self.standard_deviation = 0
    }
    
    // Gaussian distribution constructor
    init(radius: Double, numberOfDummies: Int, trueLocation: CLLocationCoordinate2D, mean: Double, standard_deviation: Double) {
        self.noiseDistribution = .gaussian
        self.radius = radius
        self.numberOfDummies = numberOfDummies
        self.trueLocation = trueLocation
        self.lambda = 0
        self.min = 0
        self.max = 0
        self.mode = 0
        self.mean = mean
        self.standard_deviation = standard_deviation
    }
    
    // Exported function
    func generateFakeLocations(location: CLLocationCoordinate2D,distribution: NoiseDistribution, dummiesRequested: Int, radius: Double) -> [CLLocationCoordinate2D]{
        var dummies: [CLLocationCoordinate2D] = []
        switch distribution {
        case .uniform:
            for _ in 0...dummiesRequested {
                dummies.append(generateUniformNoise(location: location, radius: radius))
            }
        case .poisson:
            for _ in 0...dummiesRequested {
                dummies.append(generatePoissonNoise(location: location, radius: radius, lambda: lambda))
            }
        case .gaussian:
            for _ in 0...dummiesRequested {
                dummies.append(generateGaussianNoise(location: location, radius: radius, mean: mean, standard_deviation: standard_deviation))
            }
        case .triangular:
            for _ in 0...dummiesRequested {
                dummies.append(generateTriangularNoise(location: location, radius: radius, min: min, max: max, mode: mode))
            }
        }
        return dummies
    }
    
    // Private functions
    
    // Distributions
    // Uniform distribution
    private func generateUniformNoise(location: CLLocationCoordinate2D, radius: Double) -> CLLocationCoordinate2D {
        let randomRadius: Double = Double.random(in: 0...radius)
        let randomAngle: Double = Double.random(in: 0...2 * Double.pi)
        let x: Double = kilometersToDegreesLatitude(km: randomRadius * cos(randomAngle))
        let y: Double = kilometersToDegreesLongitude(km: randomRadius * sin(randomAngle), latitude: x)
        let newLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude + x, longitude: location.longitude + y)
        return newLocation
    }
    
    // Poisson distribution
    private func generatePoissonNoise(location: CLLocationCoordinate2D, radius: Double, lambda: Double) -> CLLocationCoordinate2D {
        let randomRadius: Double = -log(1 - Double.random(in: 0...1)) / lambda
        let randomAngle: Double = Double.random(in: 0...2*Double.pi)
        let x: Double = kilometersToDegreesLatitude(km: randomRadius * cos(randomAngle))
        let y: Double = kilometersToDegreesLongitude(km: randomRadius * sin(randomAngle), latitude: x)
        let newLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude + x, longitude: location.longitude + y)
        return newLocation
    }
    
    // Triangular distribution
    private func generateTriangularNoise(location: CLLocationCoordinate2D, radius: Double, min: Double, max: Double, mode: Double) -> CLLocationCoordinate2D {
		let random = Double(arc4random()) / Double(UInt32.max)
		
        let randomRadius: Double = Double.random(in: 0...radius)
        let randomAngle: Double = Double.random(in: 0...2*Double.pi)
        let x: Double = kilometersToDegreesLatitude(km: randomRadius * cos(randomAngle))
        let y: Double = kilometersToDegreesLongitude(km: randomRadius * sin(randomAngle), latitude: x)
        let newLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude + x, longitude: location.longitude + y)
        return newLocation
    }
    
    // Gaussian distribution
    private func generateGaussianNoise(location: CLLocationCoordinate2D, radius: Double, mean: Double, standard_deviation: Double) -> CLLocationCoordinate2D {
        let randomRadius: Double = Double.random(in: 0...radius)
        let randomAngle: Double = Double.random(in: 0...2*Double.pi)
        let x: Double = kilometersToDegreesLatitude(km: randomRadius * cos(randomAngle))
        let y: Double = kilometersToDegreesLongitude(km: randomRadius * sin(randomAngle), latitude: x)
        let newLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude + x, longitude: location.longitude + y)
        return newLocation
    }
    
    // Auxiliary functions
    // Funzione che permette di trasformare da kilometri a gradi (da applicare alla latitudine)
    private func kilometersToDegreesLatitude(km: Double) -> Double {
        return km / 111.111
    }
    
    // Funzione che permette di trasformare da kilometri a gradi (da applicare alla longitudine)
    private func kilometersToDegreesLongitude(km: Double, latitude: Double) -> Double {
        return km / (111.111 * cos(latitude * Double.pi / 180))
    }
    
}