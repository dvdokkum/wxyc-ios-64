import UIKit

class RootPageViewController: UIPageViewController {
    let nowPlayingViewController = NowPlayingViewController.loadFromNib()
    let infoDetailViewController = InfoDetailViewController.loadFromNib()
    
    let nowPlayingService: NowPlayingService
    let lockscreenInfoService = LockscreenInfoService()
    
    var pages: [UIViewController] {
        return [
            nowPlayingViewController,
            infoDetailViewController
        ]
    }
    
    let webservice = Webservice()
    
    // MARK: Life cycle

    required init?(coder: NSCoder) {
        nowPlayingService = NowPlayingService(delegate: nowPlayingViewController)
        
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpBackground()
        self.setUpPages()
        self.setUpPlaylistPolling()
    }
    
    private func setUpBackground() {
        let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "background"))
        view.insertSubview(backgroundImageView, at: 0)
        backgroundImageView.frame = view.bounds
    }
    
    private func setUpPages() {
        self.dataSource = self
        
        self.setViewControllers(
            [nowPlayingViewController],
            direction: .forward,
            animated: false,
            completion: nil
        )
    }
    
    private func setUpPlaylistPolling() {
        _ = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.checkPlaylist), userInfo: nil, repeats: true)
        
        self.checkPlaylist()
    }
    
    // MARK - Customization

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Playlist stuff
    
    @objc private func checkPlaylist() {
        let playcutRequest = webservice.getCurrentPlaycut()
        playcutRequest.observe(with: self.updateWith(playcutResult:))
        
        let imageRequest = playcutRequest.getArtwork()
        imageRequest.observe(with: self.update(artworkResult:))
    }
    
    private func updateWith(playcutResult result: Result<Playcut>) {
        DispatchQueue.main.async {
            self.nowPlayingService.updateWith(playcutResult: result)
            self.lockscreenInfoService.updateWith(playcutResult: result)
        }
    }
    
    private func update(artworkResult: Result<UIImage>) {
        DispatchQueue.main.async {
            self.nowPlayingService.update(artworkResult: artworkResult)
            self.lockscreenInfoService.update(artworkResult: artworkResult)
        }
    }
}

extension RootPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case nowPlayingViewController:
            return nil
        default:
            return infoDetailViewController
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case nowPlayingViewController:
            return infoDetailViewController
        default:
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension UIViewController {
    static func loadFromNib() -> Self {
        let nibName = String(describing: self)
        return self.init(nibName: nibName, bundle: nil)
    }
}
