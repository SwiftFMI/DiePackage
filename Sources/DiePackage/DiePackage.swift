public enum DieCreationError: String, Swift.Error, CustomStringConvertible {
    case insufficientNumberOfFaces
    case oddNumberOfFaces
    case tooManyNumberFaces
    
    public var description: String {
        switch self {
        case .insufficientNumberOfFaces:
            return "A die should have at least 4 faces"
        case .oddNumberOfFaces:
            return "A die should have even number of faces (multiple of 2)"
        case .tooManyNumberFaces:
            return "A die should not have more than 120 faces, as it's physically impossible otherwise"
        }
    }
}

public struct Die<T: CustomStringConvertible> {
    public let faces: [T]
    
    public init(faces: [T]) throws {
        guard faces.count > 3 else { throw DieCreationError.insufficientNumberOfFaces }
        guard faces.count.isMultiple(of: 2) else { throw DieCreationError.oddNumberOfFaces }
        guard faces.count < 120 else { throw DieCreationError.tooManyNumberFaces }
        
        self.faces = faces
    }
}

public extension Die {
    /// Get a random face
    func roll() -> T { faces.shuffled()[0] }
}
