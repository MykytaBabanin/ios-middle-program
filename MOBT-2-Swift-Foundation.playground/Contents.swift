import Foundation
import UIKit

/// This class can help us to localize some features regarding currency exchange in case we have more than 1 country in scope
protocol ConfiguratorApplangaSpecific {
    func localizedString(_ string: String, comment: String?) -> String
    func localizedString(format: String, _ arguments: CVarArg...) -> String
}

class ConfiguratorApplanga: ConfiguratorApplangaSpecific {
    func localizedString(_ string: String, comment: String? = nil) -> String {
        let tableName = Configurator.currentTarget.localizedTableName
        var localizedValue = NSLocalizedString(string,
                                               tableName: tableName,
                                               bundle: Bundle.main,
                                               value: "",
                                               comment: comment ?? "")
        localizedValue = localizedValue.replacingOccurrences(of: "%s", with: "%@")
        
        return localizedValue
    }
    
    /// Gets localized string for `format` and passes arguments into the string
    func localizedString(format: String, _ arguments: CVarArg...) -> String {
        let localizedFormat = localizedString(format)
        return String(format: localizedFormat, arguments: arguments)
    }
}

class Configurator {
    static var currentTarget: Target = {
        guard let targetName = Bundle.main.infoDictionary?["TargetName"] as? String,
              let target = Target(rawValue: targetName) else {
                  fatalError("Cannot find current target name")
              }
        return target
    }()
}

/// This peace of code we use to separate some kind of countries for different targets
enum Target: String {
    case italy = "Italy"
    case greece = "Greece"
    case romania = "Romania"
    case netherlands = "Netherlands"
    
    var configurationPath: String {
        switch self {
        case .italy:
            return "ConfigurationItaly"
        case .greece:
            return "ConfigurationGreece"
        case .romania:
            return "ConfigurationRomania"
        case .netherlands:
            return "ConfigurationNetherlands"
        }
    }
    
    var localizedTableName: String {
        switch self {
        case .italy:
            return "LocalizedItaly"
        case .greece:
            return "LocalizedGreece"
        case .romania:
            return "LocalizedRomania"
        case .netherlands:
            return "ConfigurationNetherlands"
        }
    }
}
    
protocol CurrencyExchangeUserDefaultsProtocol {
    var storeCurrencyExchangeKey: [String] { get  set }
    var storeCurrencyExchangeValue: Any { get set }
}

final class CurrencyExchangeUserDefaults: CurrencyExchangeUserDefaultsProtocol {
    private let currencyExchangeKey = "currencyExchangeKey"
    private let currencyExchagneValue = "currencyExchangeValue"

    private let userDefaults: UserDefaults
    
    var storeCurrencyExchangeKey: [String] {
        get {
            return userDefaults.stringArray(forKey: currencyExchangeKey) ?? []
        }
        set {
            userDefaults.set(newValue, forKey: currencyExchangeKey)
        }
    }
    
    var storeCurrencyExchangeValue: Any {
        get {
            return userDefaults.object(forKey: currencyExchagneValue) ?? []
        }
        set {
            userDefaults.set(newValue, forKey: currencyExchagneValue)
        }
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
}

protocol Endpoint {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var parametres: [URLQueryItem] { get }
    var method: String { get }
}

enum CurrencyExchangeEndpoint: Endpoint {
    case getSearchResults(searchText: String?, page: Int?)
    
    var scheme: String {
        switch self {
        default:
            return "http"
        }
    }
    
    var baseURL: String {
        switch self {
        default:
            return "open.er-api.com"
        }
    }
    
    var path: String {
        switch self {
        default:
            return "/v6/latest/USD"
        }
    }
    
    var parametres: [URLQueryItem] {
        switch self {
        case .getSearchResults(searchText: let searchText, page: let page):
            return [URLQueryItem(name: "text", value: searchText),
                    URLQueryItem(name: "page", value: String(page ?? 0)),
            URLQueryItem(name: "format", value: "json")]
        }
    }
    
    var method: String {
        switch self {
        case . getSearchResults:
            return "GET"
        }
    }
}

struct CurrencyExchangeResponse: Codable {
    let rates: [String: Double]?
}

class NetworkService {
    var currency: [String: Double] = [:]
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> ()) {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parametres
        
        
        guard let url = components.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            guard response != nil, let data = data else { return }
            
            DispatchQueue.main.async {
                if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(responseObject))
                } else {
                    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}

final class CurrencyExchangeLocalData {
    private let network: NetworkService
    private let currencyExchangeUserDefaults = CurrencyExchangeUserDefaults()
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func persistNetworkData() {
        network.request(endpoint: CurrencyExchangeEndpoint.getSearchResults(searchText: "", page: 0)) { (result: Result<CurrencyExchangeResponse, Error>) in
            switch result {
            case .success(let success):
                self.network.currency = success.rates ?? [:]
                self.currencyExchangeUserDefaults.storeCurrencyExchangeKey = Array(self.network.currency.keys)
                print(self.currencyExchangeUserDefaults.storeCurrencyExchangeKey)
                self.currencyExchangeUserDefaults.storeCurrencyExchangeValue = Array(self.network.currency.values)
                print(self.currencyExchangeUserDefaults.storeCurrencyExchangeValue)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func retrieveNetworkData() {
        currencyExchangeUserDefaults.storeCurrencyExchangeKey
        currencyExchangeUserDefaults.storeCurrencyExchangeValue
    }
}

let urlSession = URLSession(configuration: .default)
let networkService = NetworkService(session: urlSession)
let currencyExchangeLocalData = CurrencyExchangeLocalData(network: networkService)
currencyExchangeLocalData.persistNetworkData()
currencyExchangeLocalData.retrieveNetworkData()

///When we have an object from the backend, we have a possibility to create MVVM-C architecture and use data to display on UI part
///This is example of MVVM-C structure of our project

///Base coordinator conforms to different coordinators to use methods of our currency exchanges

protocol BaseCoordinatorProtocol {
    func pushViewController(_ viewController: UIViewController)
    func start()
}

class BaseCoordinator: BaseCoordinatorProtocol {
    private(set) var rootController: UINavigationController
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
    }
    ///This is method which can be used in different coordinators to pushViewControllers, this method is not the only one which we can provide.
    ///We can extend our base coordinator to handle different situatuations
    func pushViewController(_ viewController: UIViewController) {
        pushViewController(viewController)
    }
    ///This function needs to display that we can handle our dependencies in this class, but if we need some kind of parametres - we can create a new start function to avoid overriding this one.
    func start() { assertionFailure("Must be overriden in subclass") }
}
///Example
class CurrencyExchangeCoordinator: BaseCoordinator {
    override func start() {
        assertionFailure("Unreachable code")
    }
    
    func start(currencyServiceLayer: NetworkService) {
        let model = CurrencyExchangeModel(serviceLayer: currencyServiceLayer)
        let viewModel = CurrencyExchangeViewModel(model: model)
        let viewController = CurrencyExchangeViewController(viewModel: viewModel)
        pushViewController(viewController)
    }
}

///This peace of code we use to override basic functions of ViewController, just conform it in your viewController
public protocol ControlSetup {
    func setupSubviews()
    func setupAutoLayout()
    func setupStyle()
    func setupActions()
}

public extension ControlSetup {
    func setupActions() { }
    
    func controlSetup() {
        setupSubviews()
        setupAutoLayout()
        setupStyle()
        setupActions()
    }
}

///ViewController can help us to introduce to user our CurrencyExchange using data from viewModel
///In this case we do not need any base classes because we don't need to handle some errors or etc.
///We can create 'Control Setup' method to easilly add base functions of our viewController

protocol CurrencyExchangeStyling {
    ///declare variables to style your viewController
}

struct CurrencyExchangeStyle: CurrencyExchangeStyling {
    ///setup your style here
}

//Example
class CurrencyExchangeViewController: UIViewController, ControlSetup {
    private let viewModel: CurrencyExchangeViewModel
    private let style = CurrencyExchangeStyle()
    
    init(viewModel: CurrencyExchangeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        //use this function to setup Subviews
        //view.addSubview() or different types of this method
    }
    
    func setupAutoLayout() {
        //You can use NSLayoutContstraints.activate([]) to handle your auto layout
    }
    
    func setupStyle() {
        // setup your style using style property
    }
}

public protocol BackendErrorProtocol {
    var reason: String { get }
    var message: String { get }
    var subject: String { get }
}

public struct BackendError: BackendErrorProtocol {
    public let reason: String
    public let message: String
    public let subject: String
    public var errorData: [String: Any]?
    
    public init(reason: String,
                message: String,
                subject: String,
                errorData: [String: Any]?) {
        self.reason = reason
        self.message = message
        self.subject = subject
        self.errorData = errorData
    }
    
    static func undefinedError() -> BackendError {
        return BackendError(reason: "Undefined error",
                            message: "",
                            subject: "",
                            errorData: nil)
    }
}

public enum DataProviderError: Error {
    case undefinedError
    case configurationSetupError
    // Usually, we need to handle only `backendError` locally and then call basic error handling
    case backendError(code: Int, errors: [BackendError])
    case offlineError
    case timeOut
    case tokenExpired
}

protocol BaseViewModelProtocol {
    func handleErrorLocally(_ error: DataProviderError)
}

class BaseViewModel: BaseViewModelProtocol {
    func handleErrorLocally(_ error: DataProviderError) {
        //In this case you need to handle an error and for example move user to a main screen.
    }
}

private enum HTTPStatusCodes: Int {
    case ok = 200
    case created //201
    case accepted //202
    case nonAuthoritativeInformation //203
    case badRequest = 400
}

/// View model can help us to create a bussiness logic of our app.
/// Then we need to send bussiness logic to viewController
class CurrencyExchangeViewModel: BaseViewModel {
    private enum Const {
        static let currencyNameNotUniqueReasonCode = "currencyNameNotUnique"
        static let currencyNameInvalidReason = "invalid"
    }
    private let model: CurrencyExchangeModel
    
    init(model: CurrencyExchangeModel) {
        self.model = model
    }
    
    private func handleError(_ error: DataProviderError) {
        //In case you need to handle errors, you can use HTTPStatusCodes to equal our native statuses to the statuses in enum.
    }
    // In this area you can use your logic.
}

///Model needs to store our data from backend.
class CurrencyExchangeModel {
    private let serviceLayer: NetworkService
    init(serviceLayer: NetworkService) {
        self.serviceLayer = serviceLayer
    }
    //We need to take our objects from the service layer
}
