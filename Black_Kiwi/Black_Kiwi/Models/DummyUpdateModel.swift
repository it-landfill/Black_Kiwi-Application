//
//  DummyUpdateModel.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 28/10/22.
//

import Foundation
import CoreLocation

class DummyUpdateModel: Codable {
    
    enum NoiseDistribution: String, CaseIterable, Codable {
        case none
        case uniform
        case gaussian
        case poisson
        case triangular
    }
    
    // Universal parameter
    let radius: Double
    let numberOfDummies: Int
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
    
    // No location distorsion constructor
    init() {
        self.noiseDistribution = .none
        self.radius = 0.1
        self.numberOfDummies = 2 // Exclude location perturbation and no perturbation
        self.lambda = 0.5
        self.min = 0
        self.max = 0
        self.mode = 0
        self.mean = 0
        self.standard_deviation = 0.1
    }
    
    // Uniform distribution constructor
    init(radius: Double, numberOfDummies: Int, trueLocation: CLLocationCoordinate2D) {
        self.noiseDistribution = .uniform
        self.radius = radius
        self.numberOfDummies = numberOfDummies
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
        self.lambda = 0
        self.min = 0
        self.max = 0
        self.mode = 0
        self.mean = mean
        self.standard_deviation = standard_deviation
    }
    
    // All param constructor (Used to load saved model)
    init(radius: Double, numberOfDummies: Int, noiseDistribution: NoiseDistribution, lambda: Double, min: Double, max: Double, mode: Double, mean: Double, standard_deviation: Double) {
		self.radius = radius
		self.numberOfDummies = numberOfDummies
		self.noiseDistribution = noiseDistribution
		self.lambda = lambda
		self.min = min
		self.max = max
		self.mode = mode
		self.mean = mean
		self.standard_deviation = standard_deviation
	}
    
    // Exported function
    func generateFakeLocations(location: CLLocationCoordinate2D) -> [CLLocationCoordinate2D]{
        var dummies: [CLLocationCoordinate2D] = []
        switch noiseDistribution {
        case .none:
            dummies.append(location)
        case .uniform:
            for _ in 0..<numberOfDummies {
                dummies.append(generateUniformNoise(location: location, radius: radius))
            }
        case .poisson:
            for _ in 0..<numberOfDummies {
                dummies.append(generatePoissonNoise(location: location, radius: radius, lambda: lambda))
            }
        case .gaussian:
            for _ in 0..<numberOfDummies {
                dummies.append(generateGaussianNoise(location: location, radius: radius, mean: mean, standard_deviation: standard_deviation))
            }
        case .triangular:
            for _ in 0..<numberOfDummies {
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
		let L = exp(-lambda)
		var p = 1.0
		var k = 0
		repeat {
			k += 1
			p *= Double.random(in: 0...1)
		} while p > L
		let randomRadius: Double = radiusCalibration(oldMaxRadius: radius, newMaxRadius:  poissonMaxBound(lambda: lambda), actualRadius: Double(k - 1))
        let randomAngle: Double = Double.random(in: 0...2*Double.pi)
        let x: Double = kilometersToDegreesLatitude(km: randomRadius * cos(randomAngle))
        let y: Double = kilometersToDegreesLongitude(km: randomRadius * sin(randomAngle), latitude: x)
        let newLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude + x, longitude: location.longitude + y)
        return newLocation
    }
    
    // Triangular distribution
    private func generateTriangularNoise(location: CLLocationCoordinate2D, radius: Double, min: Double, max: Double, mode: Double) -> CLLocationCoordinate2D {
        let random: Double = Double(arc4random()) / Double(UInt32.max)
        let area: Double = (max - min) * (mode - min) / 2
        let randomRadius: Double
        if random < area {
            randomRadius =  min + sqrt(random * (max - min) * (mode - min))
        } else {
            randomRadius =  max - sqrt((1 - random) * (max - min) * (max - mode))
        }
        let randomAngle: Double = radiusCalibration(oldMaxRadius: radius, newMaxRadius:  max, actualRadius: Double.random(in: 0...2*Double.pi))
        let x: Double = kilometersToDegreesLatitude(km: randomRadius * cos(randomAngle))
        let y: Double = kilometersToDegreesLongitude(km: randomRadius * sin(randomAngle), latitude: x)
        let newLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude + x, longitude: location.longitude + y)
        return newLocation
    }
    
    // Gaussian distribution
    private func generateGaussianNoise(location: CLLocationCoordinate2D, radius: Double, mean: Double, standard_deviation: Double) -> CLLocationCoordinate2D {
		let randomRadius: Double =  radiusCalibration(oldMaxRadius: radius, newMaxRadius:  max, actualRadius: abs(mean + standard_deviation * sqrt(-2 * log(Double.random(in: 0...1))) * cos(2 * Double.pi * Double.random(in: 0...1))))
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
    
    private func radiusCalibration(oldMaxRadius: Double, newMaxRadius: Double, actualRadius: Double) -> Double {
        return (actualRadius * newMaxRadius) / oldMaxRadius
    }
    
    private func poissonMaxBound(lambda: Double) -> Double {
        return lambda + 3 * sqrt(lambda)
    }
    
    private func gaussianMaxBound(mean: Double, std: Double) -> Double {
        return mean + 3 * std
    }
}
