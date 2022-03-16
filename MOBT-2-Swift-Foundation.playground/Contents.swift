import Foundation
import UIKit

/// These are structures to take an information from backend with using Codable
// MARK: - Structs
private struct Currency: Codable {
    var rates: [String: Double]
}

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
    case Italy = "Italy"
    case Greece = "Greece"
    case Romania = "Romania"
    case Netherlands = "Netherlands"
    
    var configurationPath: String {
        switch self {
        case .Italy:
            return "ConfigurationItaly"
        case .Greece:
            return "ConfigurationGreece"
        case .Romania:
            return "ConfigurationRomania"
        case .Netherlands:
            return "ConfigurationNetherlands"
        }
    }
    
    var localizedTableName: String {
        switch self {
        case .Italy:
            return "LocalizedItaly"
        case .Greece:
            return "LocalizedGreece"
        case .Romania:
            return "LocalizedRomania"
        case .Netherlands:
            return "ConfigurationNetherlands"
        }
    }
}

/// This is the example of getting backend part of code. And transfer this data to swift objects.
// MARK: - Typealias
public typealias EmptyClosure = () -> Void
public typealias DataKeys = (([String]) -> Void)
public typealias DataValues = (([Double]) -> Void)

public struct Keys {
    static let mostRecentExchangeRatesValues = "Keys.mostRecentExchangeRatesValue"
    static let mostRecentExchangeRatesKeys = "Keys.mostRecentExchangeRatesKeys"
}

// MARK: - Protocols
protocol CurrencyExchangeMethods {
    func fetchJSON(retreiveDataKeys: @escaping DataKeys, retrieveDataValues: @escaping DataValues)
}

// MARK: - Classes
final class CurrencyExchangeConverterService: CurrencyExchangeMethods {
    // MARK: - Enums
    private enum Const {
        static let urlAPI: String = "https://open.er-api.com/v6/latest/USD"
    }
    
    // MARK: - Properties
    var currencyCode: [String] = []
    var values: [Double] = []
    
    // MARK: - Methods
    func fetchJSON(retreiveDataKeys: @escaping DataKeys, retrieveDataValues: @escaping DataValues) {
        guard let url = URL(string: Const.urlAPI) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil { return }
            guard let data = data else { return }
            do {
                let results = try JSONDecoder().decode(Currency.self, from: data)
                self.currencyCode.append(contentsOf: results.rates.keys)
                self.values.append(contentsOf: results.rates.values)
                retreiveDataKeys(self.currencyCode)
                retrieveDataValues(self.values)
            } catch {
                print(error)
            }
        }.resume()
    }
}

final class CurrencyExchangeLocalData {
    var currencyExchangeService: CurrencyExchangeConverterService?
    
    init(currencyExchangeService: CurrencyExchangeConverterService?) {
        self.currencyExchangeService = currencyExchangeService
    }
    
    func setDataToUserDefaults() {
        currencyExchangeService?.fetchJSON(retreiveDataKeys: { keys in
            UserDefaults.standard.set(keys, forKey: Keys.mostRecentExchangeRatesKeys)
        }, retrieveDataValues: { values in
            UserDefaults.standard.set(values, forKey: Keys.mostRecentExchangeRatesValues)
        })
    }
    
    func retrieveDataFromUserDefaults() {
        let currencyKeys = UserDefaults.standard.stringArray(forKey: Keys.mostRecentExchangeRatesKeys)
        let currencyValues = UserDefaults.standard.object(forKey: Keys.mostRecentExchangeRatesValues)
        print(currencyKeys ?? "No such keys in User Defaults")
        print(currencyValues ?? "No such values in User Defaults")
    }
}

let currencyExchangeService = CurrencyExchangeConverterService()
let currencyExchangeLocalData = CurrencyExchangeLocalData(currencyExchangeService: currencyExchangeService)
currencyExchangeLocalData.setDataToUserDefaults()
currencyExchangeLocalData.retrieveDataFromUserDefaults()

///When we have an object from the backend, we have a possibility to create MVVM-C architecture and use data to display on UI part
///This is example of MVVM-C structure of our project

///Base coordinator conforms to different coordinators to use methods of our currency exchanges
class BaseCoordinator {
    private(set) weak var rootController: UINavigationController?
    
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
    
    func start(currencyServiceLayer: CurrencyExchangeConverterService) {
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
    
    var viewModel: CurrencyExchangeViewModel
    var style = CurrencyExchangeStyle()
    
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
    case OK = 200
    case Created //201
    case Accepted //202
    case NonAuthoritativeInformation //203
    case BadRequest = 400
}

/// View model can help us to create a bussiness logic of our app.
/// Then we need to send bussiness logic to viewController
class CurrencyExchangeViewModel: BaseViewModel {
    private enum Const {
        static let currencyNameNotUniqueReasonCode = "currencyNameNotUnique"
        static let currencyNameInvalidReason = "invalid"
    }
    var model: CurrencyExchangeModel
    
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
    var serviceLayer: CurrencyExchangeConverterService?
    init(serviceLayer: CurrencyExchangeConverterService) {
        self.serviceLayer = serviceLayer
    }
    //We need to take our objects from the service layer
}
