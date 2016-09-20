app.directive(
				"mAppLoading",
				function( $animate ) {

				// Return the directive configuration.
					return({
						link: link,
						restrict: "C"
					});


					// I bind the JavaScript events to the scope.
					function link( scope, element, attributes ) {
					 
						// Due to the way AngularJS prevents animation during the bootstrap
						// of the application, we can't animate the top-level container; but,
						// since we added "ngAnimateChildren", we can animated the inner
						// container during this phase.
						// --
						// NOTE: Am using .eq(1) so that we don't animate the Style block.
						$animate.leave( element.children().eq( 1 ) ).then(
						function cleanupAfterAnimation() {

							// Remove the root directive element.
							element.remove();

							// Clear the closed-over variable references.
							scope = element = attributes = null;

						});
					}

				}
);

// app.directive('draggable', ['$document' , function($document) {
//     return {
//       restrict: 'A',
//       link: function(scope, elm, attrs) {
//         var startX, startY, initialMouseX, initialMouseY;
//         elm.css({position: 'absolute'});
//         //elm.draggable();

//         elm.bind('mousedown', function($event) {
//           startX = elm.prop('offsetLeft');
//           startY = elm.prop('offsetTop');
//           initialMouseX = $event.clientX;
//           initialMouseY = $event.clientY;
//           $document.bind('mousemove', mousemove);
//           $document.bind('mouseup', mouseup);
//           return false;
//         });

//         function mousemove($event) {
//           var dx = $event.clientX - initialMouseX;
//           var dy = $event.clientY - initialMouseY;
//           elm.css({
//             top:  startY + dy + 'px',
//             left: startX + dx + 'px'
//           });
//           return false;
//         }

//         function mouseup() {
//           $document.unbind('mousemove', mousemove);
//           $document.unbind('mouseup', mouseup);
//         }
//       }
//     };
//   }]);