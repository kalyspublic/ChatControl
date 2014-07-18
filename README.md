# ChatControl

## Installation

Add the following line to your Podfile:

    pod "ChatControl", git: "https://github.com/kalyspublic/ChatControl.git"

## Usage

- Create model with ```KOChatEntryDelegate```. Example: KOChatEntry.
- Create dataSource class inherited on KOChatDataSource for tableView data provisioning. Example: MYChatDataSource.
- Impletement the following methods in your data source class:
  - ```- (NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section```
  - ```- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath```
  - ```- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath``` This method should contain:
      ```return [KOChatControlHelper cellHeight:self.entries[indexPath.row]];```
      
- Instantiate KOChatViewController. Set the following delegates:
  - ```messageFormDelegate``` for receiving __Send__ and __Camera__ button events;
  - ```delegate``` for receiving __Load more__ and __Join__ button events;
  - ```tableView.dataSource``` and ```tableView.delegate``` should point to your  data source instance. Example: MYChatDataSource.


```KOChatViewController``` has several methods for showing and hiding __Load more__ and __Join__ buttons:

    - (void) showLoadMore;
    - (void) hideLoadMore;
    - (void) showJoin;
    - (void) hideJoin;
## License

ChatControl is available under the MIT license. See the LICENSE file for more info.

